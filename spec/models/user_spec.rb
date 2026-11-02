require "rails_helper"

RSpec.describe User, type: :model do
  describe "correo" do
    it "se guarda sin espacios alrededor y en minúsculas" do
      user = create_user(email_address: "  Ana.Admin@Example.TEST  ")

      expect(user.reload.email_address).to eq("ana.admin@example.test")
    end

    it "es único aunque difiera en mayúsculas" do
      create_user(email_address: "ana.admin@example.test")
      duplicate = User.new(email_address: "ANA.ADMIN@example.test", name: "Otra", password: generated_password)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email_address]).to be_present
    end

    it "es obligatorio" do
      user = User.new(email_address: "", name: "Ana Admin", password: generated_password)

      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to be_present
    end
  end

  it "exige un nombre" do
    user = User.new(email_address: "ana.admin@example.test", name: " ", password: generated_password)

    expect(user).not_to be_valid
    expect(user.errors[:name]).to be_present
  end

  describe "política de contraseñas" do
    def user_with(password)
      User.new(email_address: "ana.admin@example.test", name: "Ana Admin", password: password)
    end

    it "rechaza 14 caracteres" do
      user = user_with("a" * 14)

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include(a_string_matching(/15/))
    end

    it "acepta 15 caracteres sin reglas de composición" do
      expect(user_with("frase de prueba")).to be_valid
    end

    it "cuenta caracteres, no bytes, para el mínimo" do
      expect(user_with("ñ" * 14)).not_to be_valid
      expect(user_with("ñ" * 15)).to be_valid
    end

    it "acepta caracteres multibyte dentro del máximo de 72 bytes" do
      password = "🔑" * 18 # 18 caracteres, 72 bytes

      expect(password.bytesize).to eq(72)
      expect(user_with(password)).to be_valid
    end

    it "rechaza más de 72 bytes aunque tenga menos de 72 caracteres" do
      password = "🔑" * 19 # 19 caracteres, 76 bytes

      expect(password.length).to be < 72
      expect(user_with(password)).not_to be_valid
    end
  end

  it "guarda la contraseña solo como hash bcrypt" do
    password = generated_password
    user = create_user(password: password)
    stored = User.connection.select_one("SELECT * FROM users WHERE id = #{user.id}")

    expect(stored["password_digest"]).to start_with("$2a$")
    expect(stored.values.map(&:to_s)).not_to include(password)
  end

  describe "#active?" do
    it "es verdadero sin fecha de desactivación" do
      expect(create_user).to be_active
    end

    it "es falso con fecha de desactivación y la cuenta se conserva" do
      user = create_user(deactivated_at: Time.current)

      expect(user).not_to be_active
      expect(User.exists?(user.id)).to be(true)
    end
  end

  it "no es administradora por defecto" do
    expect(create_user.admin).to be(false)
  end
end
