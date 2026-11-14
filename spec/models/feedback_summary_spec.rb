require "rails_helper"

# Armado del resumen por dimensión (GL-07; 4.1 con el ajuste de P-2, 3.3).
# Recibe conteos ya agrupados por dimensión y señal: no consulta la base.
RSpec.describe FeedbackSummary do
  def summary(counts) = described_class.new(counts)

  it "arma una fila por dimensión con datos, en el orden de la lista de P-1" do
    rows = summary({ %w[teamwork positive] => 2, %w[delivery improvement] => 1 }).rows

    expect(rows.map(&:label)).to eq([ "Entrega", "Trabajo en equipo" ])
  end

  it "separa Positivos, A mejorar y Neutrales, y el total es su suma (P-2)" do
    row = summary({ %w[teamwork positive] => 2, %w[teamwork improvement] => 1, %w[teamwork neutral] => 3 }).rows.first

    expect([ row.positive, row.improvement, row.neutral, row.total ]).to eq([ 2, 1, 3, 6 ])
  end

  it "cuenta 0 en las señales que no aparecen" do
    row = summary({ %w[delivery improvement] => 1 }).rows.first

    expect([ row.positive, row.improvement, row.neutral, row.total ]).to eq([ 0, 1, 0, 1 ])
  end

  it "omite las dimensiones sin datos" do
    rows = summary({ %w[communication neutral] => 1 }).rows

    expect(rows.map(&:dimension)).to eq([ "communication" ])
  end

  it "está vacío sin conteos" do
    expect(summary({})).to be_empty
    expect(summary({ %w[delivery positive] => 1 })).not_to be_empty
  end
end
