pdf.stroke_color "CCCCCC"
pdf.font "Helvetica", :size => 14
<%encontrou = false %>
<% columns.each do |column|
    if !column.name.index("_id") && encontrou == false %>
pdf.text @<%= resource_name %>.<%=column.name%>.to_s, :size => 30, :style => :bold
        <%encontrou = true %>
    <%end%>
<%end%>
pdf.stroke_horizontal_rule
pdf.move_down(20)
pdf.text "Id: " + @<%= resource_name %>.id.to_s
<% columns.each do |column|
    if column.name.index("_file_name")
        coluna = column.name.gsub("_file_name","")
%>
if !@<%= resource_name %>.<%=coluna%>_content_type.index("image/gif") && (@<%= resource_name %>.<%=coluna%>_content_type.index("image/png") || @<%= resource_name %>.<%=coluna%>_content_type.index("image/jpeg") || @<%= resource_name %>.<%=coluna%>_content_type.index("image/jpg"))
    pdf.image "#{RAILS_ROOT}/public/images/" + @<%= resource_name %>.<%=coluna%>.url.gsub(/\?.[0-9]*/,""), :at => [500, 480]
end
    <%else
        if !column.name.index("_content_type") && !column.name.index("_file_size") && !column.name.index("_updated_at")
            if column.name.index("_id")
                coluna = column.name.gsub("_id","")
    %>
pdf.text "<%=column.name.humanize%>: " + @<%= resource_name %>.<%=coluna%>.<%=coluna%>.to_s
            <%else%>
            <%if column.type.to_s == "date"%>
if @<%= resource_name %>.<%=column.name%>
            <%end%>
pdf.text "<%=column.name.humanize%>: " + @<%= resource_name %>.<%=column.name%><%if column.type.to_s == "date"%>.strftime("%d/%m/%Y")<%elsif column.type.to_s == "datetime"%>.strftime(\"%d/%m/%Y %H:%M\")<%end%>.to_s
            <%if column.type.to_s == "date"%>
else
  pdf.text "<%=column.name.humanize%>: "
end
            <%end%>
            <%end%>
       <%end%>
   <%end%>
<%end%>
pdf.bounding_box([pdf.bounds.absolute_right()-80, pdf.bounds.absolute_bottom()-10], :width => 300) do
  pdf.text "Página: " + pdf.page_count.to_s, :size => 8
end

