require "rails_helper"

# GL-08: las cuentas ficticias no son administradoras y no impiden crear el
# primer administrador (spec initial-administrator, escenario «Solo cuentas
# ficticias»). Las pruebas de GL-02 siguen en crear_administrador_spec.rb.
RSpec.describe "Administrador inicial con el conjunto ficticio" do
  it "crea el administrador y no modifica las cuentas ficticias" do
    run_sample_data
    before = User.order(:id).map(&:attributes)
    password = generated_password

    status = InitialAdministratorCommand.new(
      input: StringIO.new("#{password}\n#{password}\n"), output: StringIO.new,
      env: { "EMAIL" => "ana.admin@example.test", "NOMBRE" => "Ana Admin" }
    ).call

    expect(status).to eq(0)
    expect(User.where(admin: true).pluck(:email_address)).to eq([ "ana.admin@example.test" ])
    expect(User.where.not(email_address: "ana.admin@example.test").order(:id).map(&:attributes)).to eq(before)
  end
end
