require 'scanf'

Puppet::Parser::Functions::newfunction(
  :scanf,
  :type => :rvalue,
  :arity => 2,
  :doc => <<-DOC
Scans a string and returns an array of one or more converted values as directed by a given format string.args
See the documenation of Ruby's String::scanf method for details about the supported formats (which
are similar but not identical to the formats used in Puppet's `sprintf` function.

This function takes two mandatory arguments: the first is the String to convert, and the second
the format String.

The result of the scan is an Array, with each sucessfully scanned and transformed value.args The scanning
stops if a scan is unsuccesful and the scanned result up to that point is returned. If there was no
succesful scan at all, the result is an empty Array.

      scanf("42", "%i")[0] == 42

DOC
) do |args|
  data = args[0]
  format = args[1]
  result = data.scanf(format)
end
