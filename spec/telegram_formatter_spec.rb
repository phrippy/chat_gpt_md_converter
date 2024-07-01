require 'rspec'
require_relative '../lib/telegram_formatter'

# rubocop:disable Metrics/BlockLength
RSpec.describe ChatGptMdConverter::TelegramFormatter do
  describe '#telegram_format' do
    it 'converts bold markdown to HTML' do
      text = 'This is **bold** text'
      expect(ChatGptMdConverter::TelegramFormatter.telegram_format(text)).to eq('This is <b>bold</b> text')
    end

    it 'converts italic markdown to HTML' do
      text = 'This is _italic_ text'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(text)
      expect(output).to eq('This is <i>italic</i> text')
    end

    it 'converts italic markdown with stars to HTML' do
      text = 'This is *italic* text'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(text)
      expect(output).to eq('This is <i>italic</i> text')
    end

    it 'converts triple backticks with language to HTML' do
      input_text = "```python\nprint('Hello, world!')\n```"
      expected_output = "<pre><code class=\"language-python\">print('Hello, world!')\n</code></pre>"
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting triple backticks with language to <pre><code> tags'
    end

    it 'converts bold and underline markdown to HTML' do
      input_text = 'This is **bold** and this is __underline__.'
      expected_output = 'This is <b>bold</b> and this is <u>underline</u>.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting ** and __ to <b> and <u> tags'
    end

    it 'escapes special characters' do
      input_text = 'Avoid using < or > in your HTML.'
      expected_output = 'Avoid using &lt; or &gt; in your HTML.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed escaping < and > characters'
    end

    it 'handles nested markdown syntax' do
      input_text = 'This is **bold and _italic_** text.'
      expected_output = 'This is <b>bold and <i>italic</i></b> text.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling nested markdown syntax'
    end

    it 'handles combination of markdown elements' do
      input_text = <<~TEXT
        # Heading
        This is a test of **bold**, __underline__, and `inline code`.
        - Item 1
        * Item 2

        ```python
        for i in range(3):
            print(i)
        ```

        [Link](https://example.com)
      TEXT
      expected_output = <<~TEXT
        <b>Heading</b>\nThis is a test of <b>bold</b>, <u>underline</u>, and <code>inline code</code>.\n• Item 1\n• Item 2\n\n<pre><code class="language-python">for i in range(3):\n    print(i)\n</code></pre>\n\n<a href="https://example.com">Link</a>\n
      TEXT
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output.strip).to eq(expected_output.strip), 'Failed combining multiple markdown elements into HTML'
    end

    it 'handles nested bold within italic' do
      input_text = 'This is *__bold within italic__* text.'
      expected_output = 'This is <i><u>bold within italic</u></i> text.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting nested bold within italic markdown to HTML'
    end

    it 'handles italic within bold' do
      input_text = 'This is **bold and _italic_ together**.'
      expected_output = 'This is <b>bold and <i>italic</i> together</b>.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting italic within bold markdown to HTML'
    end

    it 'handles inline code within bold text' do
      input_text = 'This is **bold and `inline code` together**.'
      expected_output = 'This is <b>bold and <code>inline code</code> together</b>.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling inline code within bold text'
    end

    it 'handles mixed formatting tags with lists and links' do
      input_text = <<~TEXT
        - This is a list item with **bold**, __underline__, and [a link](https://example.com)
        - Another item with ***bold and italic*** text
      TEXT
      expected_output = <<~TEXT
        • This is a list item with <b>bold</b>, <u>underline</u>, and <a href="https://example.com">a link</a>
        • Another item with <b><i>bold and italic</i></b> text
      TEXT
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output.strip).to eq(expected_output.strip), 'Failed handling mixed formatting tags with lists and links'
    end

    it 'handles special characters within code blocks' do
      input_text = "Here is a code block: ```<script>alert('Hello')</script>```"
      expected_output = "Here is a code block: <pre><code>&lt;script&gt;alert('Hello')&lt;/script&gt;</code></pre>"
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed escaping special characters within code blocks'
    end

    it 'handles code block within bold text' do
      input_text = 'This is **bold with a `code block` inside**.'
      expected_output = 'This is <b>bold with a <code>code block</code> inside</b>.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling code block within bold text'
    end

    it 'handles triple backticks with nested markdown' do
      input_text = "```python\n**bold text** and __underline__ in code block```"
      expected_output = '<pre><code class="language-python">**bold text** and __underline__ in code block</code></pre>'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling markdown within triple backtick code blocks'
    end

    it 'handles unmatched code delimiters' do
      input_text = 'This has an `unmatched code delimiter.'
      expected_output = 'This has an <code>unmatched code delimiter.</code>'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling unmatched code delimiters'
    end

    it 'handles preformatted block with unusual language specification' do
      input_text = "```weirdLang\nSome weirdLang code\n```"
      expected_output = %(<pre><code class="language-weirdLang">Some weirdLang code\n</code></pre>)
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling preformatted block with unusual language specification'
    end

    it 'handles inline code within lists' do
      input_text = <<~TEXT
        - List item with `code`
        * Another `code` item
      TEXT
      expected_output = <<~TEXT
        • List item with <code>code</code>
        • Another <code>code</code> item
      TEXT
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output.strip).to eq(expected_output.strip), 'Failed handling inline code within lists'
    end

    it 'trims storage links' do
      input_text = <<~TEXT
        - List item with `code`
        * Another `code` item#{' '}
      TEXT
      expected_output = <<~TEXT
        • List item with <code>code</code>
        • Another <code>code</code> item
      TEXT
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output.strip).to eq(expected_output.strip), 'Failed trim storage links'
    end

    it 'converts strikethrough markdown to HTML' do
      input_text = 'This is ~~strikethrough~~ text.'
      expected_output = 'This is <s>strikethrough</s> text.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting ~~ to <s> tags'
    end

    it 'converts blockquote markdown to HTML' do
      input_text = '> This is a blockquote.'
      expected_output = '<blockquote>This is a blockquote.</blockquote>'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting > to <blockquote> tags'
    end

    it 'converts inline URL markdown to HTML' do
      input_text = '[example](https://example.com)'
      expected_output = '<a href="https://example.com">example</a>'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting [text](URL) to <a> tags'
    end

    it 'converts inline mention markdown to HTML' do
      input_text = '[User](tg://user?id=123456789)'
      expected_output = '<a href="tg://user?id=123456789">User</a>'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed converting [text](tg://user?id=ID) to <a> tags'
    end

    it 'escapes ampersand character' do
      input_text = 'Use & in your HTML.'
      expected_output = 'Use &amp; in your HTML.'
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed escaping & character'
    end

    it 'handles pre and code tags with HTML entities' do
      input_text = "```html\n<div>Content</div>\n```"
      expected_output = %(<pre><code class="language-html">&lt;div&gt;Content&lt;/div&gt;\n</code></pre>)
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling pre and code tags with HTML entities'
    end

    it 'handles code with multiple lines' do
      input_text = "```\ndef example():\n    return 'example'\n```"
      expected_output = "<pre><code>def example():\n    return 'example'\n</code></pre>"
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output).to eq(expected_output), 'Failed handling code with multiple lines'
    end

    it 'handles combined formatting with lists' do
      input_text = <<~TEXT
        - **Bold** list item
        - _Italic_ list item
        - `Code` list item
      TEXT
      expected_output = <<~TEXT
        • <b>Bold</b> list item
        • <i>Italic</i> list item
        • <code>Code</code> list item
      TEXT
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output.strip).to eq(expected_output.strip), 'Failed handling combined formatting with lists'
    end

    it 'handles large markdown example' do
      input_text = <<~TEXT
        1. **Headings:**
        # H1 Heading
        ## H2 Heading
        ### H3 Heading
        #### H4 Heading
        ##### H5 Heading
        ###### H6 Heading

        2. **Emphasis:**

        *Italic text* or _Italic text_

        **Bold text** or __Underline text__

        ***Bold and italic text*** or ___Underline and italic text___

        3. **Lists:**
           - **Unordered List:**

           - Item 1
           - Item 2
             - Subitem 1
             - Subitem 2

           - **Ordered List:**

           1. First item
           2. Second item
              1. Subitem 1
              2. Subitem 2

        4. **Links:**

        [OpenAI](https://www.openai.com)

        5. **Images:**

        ![Alt text for image](URL_to_image)
        ![Alt text for image](URL_to_імедж)

        6. **Blockquotes:**

        > This is a blockquote.
        > It can span multiple lines.

        7. **Inline Code:**

        Here is some `inline code`.

        8. **Code Blocks:**

        ```python
        def example_function():
            print("Hello World")
        ```

        9. **Tables:**

        | Header 1 | Header 2 |
        |----------|----------|
        | Row 1 Col 1 | Row 1 Col 2 |
        | Row 2 Col 1 | Row 2 Col 2 |

        10. **Horizontal Rule:**

        ---
      TEXT
      expected_output = <<~TEXT
        1. <b>Headings:</b>
        <b>H1 Heading</b>
        <b>H2 Heading</b>
        <b>H3 Heading</b>
        <b>H4 Heading</b>
        <b>H5 Heading</b>
        <b>H6 Heading</b>

        2. <b>Emphasis:</b>

        <i>Italic text</i> or <i>Italic text</i>

        <b>Bold text</b> or <u>Underline text</u>

        <b><i>Bold and italic text</i></b> or <u><i>Underline and italic text</i></u>

        3. <b>Lists:</b>
           • <b>Unordered List:</b>

           • Item 1
           • Item 2
             • Subitem 1
             • Subitem 2

           • <b>Ordered List:</b>

           1. First item
           2. Second item
              1. Subitem 1
              2. Subitem 2

        4. <b>Links:</b>

        <a href="https://www.openai.com">OpenAI</a>

        5. <b>Images:</b>

        <a href="URL_to_image">Alt text for image</a>
        <a href="URL_to_імедж">Alt text for image</a>

        6. <b>Blockquotes:</b>

        <blockquote>This is a blockquote.
        It can span multiple lines.</blockquote>

        7. <b>Inline Code:</b>

        Here is some <code>inline code</code>.

        8. <b>Code Blocks:</b>

        <pre><code class="language-python">def example_function():
            print("Hello World")
        </code></pre>

        9. <b>Tables:</b>

        | Header 1 | Header 2 |
        |----------|----------|
        | Row 1 Col 1 | Row 1 Col 2 |
        | Row 2 Col 1 | Row 2 Col 2 |

        10. <b>Horizontal Rule:</b>

        ---
      TEXT
      output = ChatGptMdConverter::TelegramFormatter.telegram_format(input_text)
      expect(output.strip).to eq(expected_output.strip), 'Failed handling large markdown example'
    end
  end
end
# rubocop:enable Metrics/BlockLength
