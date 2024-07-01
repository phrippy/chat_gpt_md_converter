module ChatGptMdConverter
  module Extractors
    def ensure_closing_delimiters(text)
      text += '```' if text.scan('```').size.odd?
      text += '`' if text.scan('`').size.odd?
      text
    end

    def extract_and_convert_code_blocks(text)
      text = ensure_closing_delimiters(text)
      placeholders = []
      code_blocks = {}

      replacer = lambda do |match|
        language = match[1] || ''
        code_content = match[3]
        placeholder = "CODEBLOCKPLACEHOLDER#{placeholders.length}"
        placeholders << placeholder
        html_code_block = if language.empty?
                            "<pre><code>#{code_content}</code></pre>"
                          else
                            "<pre><code class=\"language-#{language}\">#{code_content}</code></pre>"
                          end
        [placeholder, html_code_block]
      end

      modified_text = text.dup
      text.scan(/(```(\w*)?(\n)?(.*?)```)/m).each do |match|
        placeholder, html_code_block = replacer.call(match)
        code_blocks[placeholder] = html_code_block
        modified_text.sub!(match[0], placeholder)
      end

      [modified_text, code_blocks]
    end

    def reinsert_code_blocks(text, code_blocks)
      code_blocks.each do |placeholder, html_code_block|
        text.gsub!(placeholder, html_code_block)
      end
      text
    end
  end
end
