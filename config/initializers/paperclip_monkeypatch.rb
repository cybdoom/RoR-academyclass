# Change the default Paperclip path and URL options to remain consistent with pre 3.0 version
module Paperclip
  class Attachment
    def self.default_options
      @default_options ||= {
        :convert_options       => {},
        :default_style         => :original,
        :default_url           => "/:attachment/:style/missing.png",
        :escape_url            => true,
        :restricted_characters => /[&$+,\/:;=?@<>\[\]\{\}\|\\\^~%# ]/,
        :hash_data             => ":class/:attachment/:id/:style/:updated_at",
        :hash_digest           => "SHA1",
        :interpolator          => Paperclip::Interpolations,
        :only_process          => [],
        :path                  => ":rails_root/public:url",
        :preserve_files        => false,
        :processors            => [:thumbnail],
        :source_file_options   => {},
        :storage               => :filesystem,
        :styles                => {},
        :url                   => "/system/:attachment/:id/:style/:filename", # this is the only line which is different to the original
        :url_generator         => Paperclip::UrlGenerator,
        :use_default_time_zone => true,
        :use_timestamp         => true,
        :whiny                 => Paperclip.options[:whiny] || Paperclip.options[:whiny_thumbnails]
      }
    end
  end
end