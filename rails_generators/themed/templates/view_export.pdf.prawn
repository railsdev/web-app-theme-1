pdf.stroke_color "CCCCCC"
pdf.font "Helvetica", :size => 10
iContador = 0
iAltura = 480

pagina = pdf.lazy_bounding_box([pdf.bounds.absolute_right()-80, pdf.bounds.absolute_bottom()-10], :width => 300) do
  pdf.text "Página: " + pdf.page_count.to_s, :size => 8
end
head_id = pdf.lazy_bounding_box [0,iAltura], :width => 20 do
  pdf.text "ID", :style => :bold
end
<%
  tamanho = -80
  columns.each do |column|
    tamanho += 100
    if column.name.index("_file_name")
        coluna = column.name.gsub("_file_name","")%>
head_<%=coluna%> = pdf.lazy_bounding_box [<%= tamanho %>,iAltura], :width => 100 do
  pdf.text "<%=coluna.humanize%>", :style => :bold
end
    <%else
        if !column.name.index("_content_type") && !column.name.index("_file_size") && !column.name.index("_updated_at") && column.type.to_s != "text"%>
head_<%=column.name%> = pdf.lazy_bounding_box [<%= tamanho %>,iAltura], :width => 100 do
  pdf.text "<%=column.name.humanize%>", :style => :bold
end
        <%end%>
    <%end%>
<%end%>

pdf.text "Listagem de <%= plural_model_name %>", :size => 30, :style => :bold
pdf.move_down(40)
pagina.draw
head_id.draw
<%columns.each do |column|%>
    <%if column.name.index("_file_name")
        coluna = column.name.gsub("_file_name","")%>
head_<%=coluna%>.draw
    <%else
        if !column.name.index("_content_type") && !column.name.index("_file_size") && !column.name.index("_updated_at") && column.type.to_s != "text"%>
head_<%=column.name%>.draw
        <%end%>
    <%end%>
<%end%>
pdf.stroke_horizontal_rule

@<%= plural_resource_name %>.map do |item|
  iAltura = iAltura-40
  pdf.bounding_box [0,iAltura], :width => 20 do
    pdf.text item.id.to_s
  end
<%
  tamanho = -80
  columns.each do |column|
    tamanho += 100
%>
    <%if column.name.index("_file_name")
        coluna = column.name.gsub("_file_name","")%>
pdf.bounding_box [<%=tamanho%>,iAltura], :width => 100 do
    if !item.<%=coluna%>_content_type.index("image/gif") && (item.<%=coluna%>_content_type.index("image/png") || item.<%=coluna%>_content_type.index("image/jpeg") || item.<%=coluna%>_content_type.index("image/jpg"))
        pdf.image open("#{RAILS_ROOT}/public/images/" + item.<%=coluna%>.url.gsub(/\?.[0-9]*/,""))
    else
        pdf.text "sem informação"
    end
end
    <%else
        if !column.name.index("_content_type") && !column.name.index("_file_size") && !column.name.index("_updated_at") && column.type.to_s != "text"
            if column.name.index("_id")
                coluna = column.name.gsub("_id","")
    %>
pdf.bounding_box [<%=tamanho%>,iAltura], :width => 100 do
    pdf.text item.<%=coluna%>.<%=coluna%>.to_s
end
            <%else%>
pdf.bounding_box [<%=tamanho%>,iAltura], :width => 100 do
<%if column.type.to_s == "date"%>
if item.<%=column.name%>
<%end%>
    pdf.text item.<%=column.name%><%if column.type.to_s == "date"%>.strftime("%d/%m/%Y")<%elsif column.type.to_s == "datetime"%>.strftime("%d/%m/%Y %H:%M")<%end%>.to_s
<%if column.type.to_s == "date"%>
else
    pdf.text " "
end
<%end%>
end
            <%end%>
       <%end%>
   <%end%>
<%end%>
  pdf.stroke_horizontal_rule
  if iAltura < 90
      iAltura = 480
      pdf.start_new_page
      pdf.text "Listagem de <%= plural_model_name %>", :size => 30, :style => :bold
      pdf.move_down(40)
      pagina.draw
      head_id.draw
<%columns.each do |column|%>
    <%if column.name.index("_file_name")
        coluna = column.name.gsub("_file_name","")%>
      head_<%=coluna%>.draw
    <%else
        if !column.name.index("_content_type") && !column.name.index("_file_size") && !column.name.index("_updated_at")%>
      head_<%=column.name%>.draw
        <%end%>
    <%end%>
<%end%>
      pdf.stroke_horizontal_rule
      iContador = 0
  else
      iContador += 1
  end
end

