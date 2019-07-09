module ApplicationHelper

	def pluralize(count, noun, text = nil)
  	if count != 0
    	count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
 		end
	end

end
