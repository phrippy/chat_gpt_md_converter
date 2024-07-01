module ChatGptMdConverter
  module Converters
    def convert_html_chars(text)
      text.gsub('&', '&amp;')
          .gsub('<', '&lt;')
          .gsub('>', '&gt;')
    end

    def split_by_tag(out_text, md_tag, html_tag)
      tag_pattern = Regexp.new("(?<!\\w)#{Regexp.escape(md_tag)}(.*?)#{Regexp.escape(md_tag)}(?!\\w)", Regexp::MULTILINE)
      out_text.gsub(tag_pattern, "<#{html_tag}>\\1</#{html_tag}>")
    end
  end
end
