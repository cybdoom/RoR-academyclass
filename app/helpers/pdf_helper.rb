# encoding: utf-8
module PdfHelper
  def textile_to_prawn(string, options={})
    string = string.dup
    string.gsub!(/\r/, "")
    string.gsub!(/^\*(.*)\*$/) {|s| options[:bold] ? "<b>#{$1}</b>" : $1 }
    string.gsub!(/^\*(.*)$/) {|s| "• " + $1}
    string
  end
end