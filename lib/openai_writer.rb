require 'openai'
require 'prawn'
require_relative 'utils'

class OpenAIWriter
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def generate_letter(job)
    prompt = <<~PROMPT
      Write a short, professional Ruby on Rails cover letter for:
      Title: #{job[:title]}
      Company: #{job[:company]}
      Location: #{job[:location]}

      Use the following job description as context:
      #{job[:description]}
    PROMPT

    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    content = response.dig("choices", 0, "message", "content")
    basename = sanitize_filename("#{job[:company]}_#{job[:title]}")
    pdf_path = "./cover_letters/#{basename}.pdf"
    txt_path = "./cover_letters/#{basename}.txt"

    Prawn::Document.generate(pdf_path) { text content }
    File.write(txt_path, content)

    puts "📄 Generated cover letter for #{job[:title]} at #{job[:company]}"
    {
      pdf: pdf_path,
      txt: txt_path,
      content: content
    }
  end
end
