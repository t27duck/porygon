module ApplicationHelper
  def link_to_add_fields(name, f, association, html_options = {})
    html_class = html_options.delete(:class)
    new_object = f.object.public_send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to name, {
      class: "add-fields btn btn-sm btn-primary #{html_class}",
      data: { id: id, fields: fields.delete("\n") }
    }.merge(html_options) do
      content_tag(:span, nil, class: "glyphicon glyphicon-plus")+" Add"
    end
  end
end
