module MongoBrowser
  module Models
    class Pager
      PER_PAGE = 25

      attr_reader :page
      attr_reader :size

      def initialize(page, size)
        @size = size
        @page = if page.to_i <= 0 then
                  1
                else
                  [page.to_i, total_pages].min
                end
      end

      def per_page
        PER_PAGE
      end

      def offset
        (page - 1) * per_page
      end

      def total_pages
        if size == 0 then
          1
        else
          (size.to_f / per_page).ceil
        end
      end

      def to_hash
        {
            size: size,
            page: page,
            total_pages: total_pages
        }
      end
    end
  end
end
