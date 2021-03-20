# frozen_string_literal: true

require_relative 'ui'
require_relative 'heroi'

def le_mapa(numero)
  arquivo = "mapa#{numero}.txt"
  texto = File.read arquivo
  mapa = texto.split "\n"
end

def encontra_jogador(mapa)
  caracter_do_heroi = 'H'

  mapa.each_with_index do |linha_atual, linha|
    coluna_do_heroi = linha_atual.index caracter_do_heroi

    if coluna_do_heroi
      jogador = Heroi.new
      jogador.linha = linha
      jogador.coluna = coluna_do_heroi
      return jogador
    end
  end
  nil
end

def posicao_valida?(mapa, posicao)
  linhas = mapa.size
  colunas = mapa[0].size

  estourou_linha = posicao[0].negative? || posicao[0] >= linhas
  estourou_coluna = posicao[1].negative? || posicao[1] >= colunas

  return false if estourou_linha || estourou_coluna

  valor_atual = mapa[posicao[0]][posicao[1]]

  return false if valor_atual == 'X' || valor_atual == 'F'

  true
end

def soma_vetor(vetor1, vetor2)
  [vetor1[0] + vetor2[0], vetor1[1] + vetor2[1]]
end

def posicoes_validas_a_partir_de(mapa, novo_mapa, posicao)
  posicoes = []
  movimentos = [[+1, 0], [0, +1], [-1, 0], [0, -1]]

  movimentos.each do |movimento|
    nova_posicao = soma_vetor movimento, posicao

    if posicao_valida?(mapa, nova_posicao) && posicao_valida?(novo_mapa, nova_posicao)
      posicoes << nova_posicao
    end
  end

  posicoes
end

def move_fantasma(mapa, novo_mapa, linha, coluna)
  posicoes = posicoes_validas_a_partir_de mapa, novo_mapa, [linha, coluna]

  return if posicoes.empty?

  aleatoria = rand posicoes.size
  posicao = posicoes[aleatoria]
  mapa[linha][coluna] = ' '
  novo_mapa[posicao[0]][posicao[1]] = 'F'
end

def copia_mapa(mapa)
  mapa.join("\n").tr('F', ' ').split("\n")
end

def move_fantasmas(mapa)
  caractere_do_fantasma = 'F'
  novo_mapa = copia_mapa mapa

  mapa.each_with_index do |linha_atual, linha|
    linha_atual.chars.each_with_index do |caracter_atual, coluna|
      eh_fantasma = caracter_atual == caractere_do_fantasma

      if eh_fantasma
        move_fantasma mapa, novo_mapa, linha, coluna
      end
    end
  end
  novo_mapa
end

def jogador_perdeu?(mapa)
  perdeu = !encontra_jogador(mapa)
end

def joga(nome)
  mapa = le_mapa 2

  while true
    desenha mapa
    direcao = pede_movimento
    heroi = encontra_jogador mapa

    nova_posicao = heroi.
      calcula_nova_posicao direcao

    next if !posicao_valida? mapa, nova_posicao.to_array

    mapa[heroi.coluna][heroi.linha] = ' '
    mapa[nova_posicao.linha][nova_posicao.coluna] = 'H'

    mapa = move_fantasmas mapa
    if jogador_perdeu?(mapa)
      game_over
      break
    end
  end

end

def inicia_fogefoge
  nome = da_boas_vindas
  joga nome
end