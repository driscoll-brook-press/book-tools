class WriteSpan
  def initialize(translator, output, span_class)
    @translator = translator
    @output = output
    @span_class = span_class
  end

  def execute
    @output.write "<span class='#{@span_class}'>"
    @translator.write_text 'span'
    @translator.copy_argument
  end
end
