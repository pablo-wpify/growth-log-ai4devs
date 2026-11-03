# Development-only data. Called from db/seeds.rb only in development.
# Intentionally empty: db:prepare runs the seeds when it creates a database,
# so fictitious accounts, people and assignments are NOT created here. Use the
# explicit task bin/rails growth_log:datos_ficticios (GL-08) instead.
module DevelopmentSeeds
  def self.run
  end
end
