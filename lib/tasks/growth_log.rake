namespace :growth_log do
  desc "Crea el primer administrador (EMAIL y NOMBRE opcionales; la contraseña se pide sin eco)"
  task crear_administrador: :environment do
    status = InitialAdministratorCommand.new.call
    exit(status) unless status.zero?
  end
end
