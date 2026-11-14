# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
Rails.application.config.filter_parameters += [
  :passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc,
  # GL-06 (F12, RN-5): el texto del feedback no aparece en los logs. El filtro
  # es por coincidencia parcial: cualquier parámetro que contenga estos
  # nombres también se filtra.
  :context, :evidence, :impact
]
