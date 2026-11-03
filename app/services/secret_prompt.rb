require "io/console"

# Lectura de una contraseña sin mostrarla (GL-02, extraída en GL-08). Sin eco
# cuando hay una terminal; desde la entrada estándar cuando no la hay. Nunca
# escribe la contraseña en la salida.
class SecretPrompt
  def initialize(input:, output:)
    @input = input
    @output = output
  end

  def ask(prompt)
    if @input.respond_to?(:tty?) && @input.tty? && IO.console
      IO.console.getpass(prompt)
    else
      @output.print prompt
      line = @input.gets
      @output.puts
      line&.chomp
    end
  end
end
