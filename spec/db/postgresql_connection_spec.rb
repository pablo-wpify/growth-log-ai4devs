require "rails_helper"

RSpec.describe "PostgreSQL connection" do
  let(:connection) { ActiveRecord::Base.connection }

  it "runs a real query against the PostgreSQL 18 test database" do
    server_version = connection.select_value("SHOW server_version_num").to_i

    expect(connection.adapter_name).to eq("PostgreSQL")
    expect(connection.current_database).to eq("growth_log_test")
    expect(server_version / 10_000).to eq(18)
  end
end
