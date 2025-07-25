require 'mail'

class EmailSender
  def initialize
    Mail.defaults do
      delivery_method :smtp, {
        address: "smtp.gmail.com",
        port: 587,
        user_name: ENV['EMAIL_FROM'],
        password: ENV['EMAIL_PASSWORD'],
        authentication: 'plain',
        enable_starttls_auto: true
      }
    end
  end

  def send(letter)
    Mail.new do
      from    ENV['EMAIL_FROM']
      to      ENV['EMAIL_TO']
      subject "ApplyGenius Cover Letter for #{File.basename(letter[:pdf])}"
      body    "Here is your AI-generated cover letter."
      add_file letter[:pdf]
      add_file letter[:txt]
    end.deliver!

    puts "📧 Email sent with attachments: #{File.basename(letter[:pdf])}"
  end
end
