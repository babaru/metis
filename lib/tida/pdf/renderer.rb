module Tida
  module Pdf
    class Renderer
      def initialize()
      end

      def self.render(html, options={})
        File.open File.join(Rails.root, 'public/test.html'), 'rb' do |file|
          kit = PDFKit.new(file.read, page_size: 'A4')
          kit.stylesheets << File.join(Rails.root, 'public/test.css')
          kit.to_file(File.join(Rails.root, 'tmp/test.html.pdf'))
        end
      end
    end
  end
end
