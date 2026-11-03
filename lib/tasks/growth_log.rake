namespace :growth_log do
  desc "Crea el primer administrador (EMAIL y NOMBRE opcionales; la contraseña se pide sin eco)"
  task crear_administrador: :environment do
    status = InitialAdministratorCommand.new.call
    exit(status) unless status.zero?
  end
end

namespace :growth_log do
  desc "Prepara el conjunto de datos ficticios de desarrollo (solo en development; no modifica ni borra registros existentes)"
  task datos_ficticios: :environment do
    status = DevelopmentSampleDataCommand.new.call
    exit(status) unless status.zero?
  end

  desc "Establece la contraseña de una cuenta del conjunto ficticio (solo en development; EMAIL opcional; la contraseña se pide sin eco)"
  task contrasena_ficticia: :environment do
    status = SampleAccountPasswordCommand.new.call
    exit(status) unless status.zero?
  end
end
