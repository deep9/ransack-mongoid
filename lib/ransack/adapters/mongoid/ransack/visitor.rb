module Ransack
  class Visitor
    def visit_and(object)
      nodes = object.values.map { |o| accept(o) }.compact
      nodes.inject(&:and)
    end

    def quoted?(object)
      case object
      when Arel::Nodes::SqlLiteral, Bignum, Fixnum
        false
      else
        true
      end
    end

    def visit_Ransack_Nodes_Sort(object)
      return unless object.valid?
      if object.attr.is_a?(Arel::Attributes::Attribute)
        object.attr.send(object.dir)
      else
        ordered(object)
      end
    end

    private

      def ordered(object)
        case object.dir
        when 'asc'.freeze
          Arel::Nodes::Ascending.new(object.attr)
        when 'desc'.freeze
          Arel::Nodes::Descending.new(object.attr)
        end
      end

  end
end
