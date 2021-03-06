class PastiePacker
  attr_accessor :format, :extra_message
  attr_accessor :args

  def private?; @private; end
  def to_stdout?; @to_stdout; end
  def no_header?; @no_header; end

  def parse_options(args)
    @private = false
    @format  = "ruby"
    @extra_message = nil
    @to_stdout = false
    @no_header = false

    OptionParser.new do |opts|
      opts.banner = <<BANNER
Prepare to pack or unpack piles of files with the pastiepacker.

To pack a folder: #{File.basename($0)}
To pack some files ending with "txt": find * | grep "txt$" | #{File.basename($0)}
- It outputs the url of the prepared pastie, so you can pipe it to xargs:
- pastiepacker | xargs open

To unpack a packed pastie: #{File.basename($0)} http://pastie.caboo.se/175183
- This unpacks the files into a subfolder 175138/

Options are:
BANNER
      opts.separator ""
      opts.on("-f", "--format=FORMAT", String,
              "Possess pasties with a particular persona",
              "Supported formats:",
              AVAILABLE_PARSERS.join(', '),
              "Ignored for unpacking",
              "Default: ruby") { |x| @format = x }
      opts.on("-m", "--message=MESSAGE", String,
              "Promotional passage for your pastie",
              "Default: standard 'about' message") { |x| @extra_message = x }
      opts.on("-p", "--private",
              "Posted pasties are private",
              "Ignored for unpacking",
              "Default: false") { |x| @private = x }
      opts.on("-s", "--stdout",
              "Prints packed pasties instead of posting",
              "Default: false") { |x| @to_stdout = x }
      opts.on("-H", "--no-header",
              "Prevents placing pastiepacker promotion in pasties",
              "That is, no 'about:' section is added to the top of pasties",
              "Default: false") { |x| @no_header = !x }
      opts.on("-h", "--help",
              "Show this help message.") { puts opts; exit }
      self.args = opts.parse!(args)
    end
  end
end