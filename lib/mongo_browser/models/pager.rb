module MongoBrowser
  module Models
    class Pager
      PER_PAGE = 25

      attr_reader :current_page
      attr_reader :size

      def initialize(current_page, size)
        @size = size
        @current_page = if current_page.to_i <= 0 then 1
                        else
                          [current_page.to_i, total_pages].min
                        end
      end

      def per_page
        PER_PAGE
      end

      def offset
        (current_page - 1) * per_page
      end

      def total_pages
        if size == 0 then 1
        else (size.to_f / per_page).ceil
        end
      end
    end
  end
end
