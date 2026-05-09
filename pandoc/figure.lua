-- figure.lua – centra imagens que estão sozinhas num parágrafo
function Para(para)
  -- Verifica se o parágrafo contém apenas uma imagem
  if #para.content == 1 and para.content[1].t == "Image" then
    local img = para.content[1]
    return {
      pandoc.RawBlock('latex', '\\begin{center}'),
      pandoc.Para { img },
      pandoc.RawBlock('latex', '\\end{center}')
    }
  end
end
