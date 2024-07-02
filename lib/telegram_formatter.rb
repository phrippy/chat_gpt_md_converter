require 'rexml/document'
require_relative 'version'
require_relative 'converters'
require_relative 'extractors'
require_relative 'formatters'
require_relative 'helpers'

module ChatGptMdConverter
  module TelegramFormatter
    extend ChatGptMdConverter::Converters
    extend ChatGptMdConverter::Extractors
    extend ChatGptMdConverter::Formatters
    extend ChatGptMdConverter::Helpers

    def self.telegram_format(text)
      text = combine_blockquotes(text)

      text = convert_html_chars(text)

      output, code_blocks = extract_and_convert_code_blocks(text)

      output = output.gsub('<', '&lt;').gsub('>', '&gt;')

      output = output.gsub(/`(.*?)`/, '<code>\1</code>')

      output = output.gsub(/\*\*\*(.*?)\*\*\*/, '<b><i>\1</i></b>')
      output = output.gsub(/___(.*?)___/, '<u><i>\1</i></u>')

      output = split_by_tag(output, '**', 'b')
      output = split_by_tag(output, '__', 'u')
      output = split_by_tag(output, '_', 'i')
      output = split_by_tag(output, '*', 'i')
      output = split_by_tag(output, '~~', 's')

      output = output.gsub(/【[^】]+】/, '')

      output = output.gsub(/!?\[(.*?)\]\((.*?)\)/, '<a href="\2">\1</a>')

      output = output.gsub(/^\s*#+ (.+)/, '<b>\1</b>')

      output = output.gsub(/^(\s*)[*-] (.+)/, '\1• \2')

      output = reinsert_code_blocks(output, code_blocks)

      remove_blockquote_escaping(output)
    end

    def combine_blockquotes(text)
      lines = text.split("\n")
      combined_lines = []
      blockquote_lines = []
      in_blockquote = false

      lines.each do |line|
        if line.start_with?('>')
          in_blockquote = true
          blockquote_lines << line[1..].strip
        else
          if in_blockquote
            combined_lines << "<blockquote>#{blockquote_lines.join("\n")}</blockquote>"
            blockquote_lines = []
            in_blockquote = false
          end
          combined_lines << line
        end
      end

      combined_lines << "<blockquote>#{blockquote_lines.join("\n")}</blockquote>" if in_blockquote

      combined_lines.join("\n")
    end
  end
end
