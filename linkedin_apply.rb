require 'dotenv/load'
require_relative 'lib/linkedin_bot'
require_relative 'lib/openai_writer'
require_relative 'lib/email_sender'
require_relative 'lib/job_logger'
require_relative 'lib/google_sheets_logger'

bot       = LinkedInBot.new
writer    = OpenAIWriter.new
mailer    = EmailSender.new
csv_logger   = JobLogger.new
sheet_logger = GoogleSheetsLogger.new

bot.login
bot.search_jobs

bot.each_easy_apply_job do |job|
  next if csv_logger.applied?(job)

  letter = writer.generate_letter(job)
  mailer.send(letter)
  bot.fill_form(letter)
  applied = bot.submit_if_simple

  if applied
    csv_logger.log(job, "Applied")
    sheet_logger.log(job, letter)
  else
    csv_logger.log(job, "Skipped (Multi-step)")
  end
end

bot.shutdown
