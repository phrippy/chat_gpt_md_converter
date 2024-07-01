module ChatGptMdConverter
  module Formatters
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
