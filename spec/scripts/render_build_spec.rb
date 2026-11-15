require "rails_helper"
require "open3"
require "tmpdir"

# Script de build de la instancia demo (GL-10, P-28). Se ejecuta en una copia
# aislada con `bundle` y `bin/rails` reemplazados por registros de llamadas:
# no instala nada, no compila assets y no toca ninguna base.
RSpec.describe "bin/render-build.sh" do
  let(:script) { Rails.root.join("bin/render-build.sh") }

  def run_build(env:, fail_on: nil)
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "bin"))
      FileUtils.mkdir_p(File.join(dir, "stubs"))
      FileUtils.cp(script, File.join(dir, "bin/render-build.sh"))
      log = File.join(dir, "calls.log")

      stub = <<~SH
        #!/usr/bin/env bash
        echo "$(basename "$0") $*" >> "#{log}"
        if [ -n "#{fail_on}" ] && [ "$*" = "#{fail_on}" ]; then exit 3; fi
        exit 0
      SH
      [ File.join(dir, "bin/rails"), File.join(dir, "stubs/bundle") ].each do |path|
        File.write(path, stub)
        File.chmod(0o755, path)
      end

      path = "#{File.join(dir, 'stubs')}:#{ENV.fetch('PATH')}"
      base = { "PATH" => path, "GROWTH_LOG_DEMO_INSTANCE" => nil }
      output, status = Open3.capture2e(base.merge(env), "bash", "bin/render-build.sh", chdir: dir)
      calls = File.exist?(log) ? File.readlines(log, chomp: true) : []
      return [ output, status, calls ]
    end
  end

  it "existe y es ejecutable" do
    expect(File.executable?(script)).to be(true)
  end

  it "sin el indicador migra y no invoca la tarea demo" do
    output, status, calls = run_build(env: {})

    expect(status.exitstatus).to eq(0), output
    expect(calls).to include("rails db:migrate")
    expect(calls).not_to include(a_string_including("growth_log:datos_demo"))
    expect(output).to include("Tarea demo no habilitada")
  end

  it "con el indicador migra y después invoca la tarea demo" do
    output, status, calls = run_build(env: { "GROWTH_LOG_DEMO_INSTANCE" => "growth-log-entrega-2" })

    expect(status.exitstatus).to eq(0), output
    expect(calls.index("rails db:migrate")).to be < calls.index("rails growth_log:datos_demo")
  end

  it "falla si falla la tarea demo" do
    _output, status, _calls = run_build(env: { "GROWTH_LOG_DEMO_INSTANCE" => "otra-instancia" }, fail_on: "growth_log:datos_demo")

    expect(status.exitstatus).not_to eq(0)
  end

  it "falla si fallan las migraciones y no invoca la tarea" do
    _output, status, calls = run_build(env: { "GROWTH_LOG_DEMO_INSTANCE" => "growth-log-entrega-2" }, fail_on: "db:migrate")

    expect(status.exitstatus).not_to eq(0)
    expect(calls).not_to include(a_string_including("growth_log:datos_demo"))
  end

  it "no muestra el entorno ni activa el modo de traza" do
    content = File.readlines(script).drop(1).join

    expect(content).not_to match(/set\s+-[a-z]*x|\benv\b|printenv|export\s+-p/)
  end
end
