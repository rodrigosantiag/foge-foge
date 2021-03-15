# frozen_string_literal: true

require_relative 'ui'

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
      return [linha, coluna_do_heroi]
    end
  end
  # não achei
end

def calcula_nova_posicao(heroi, direcao)
  heroi = heroi.dup
  movimentos = {
    'W' => [-1, 0],
    'S' => [+1, 0],
    'A' => [0, -1],
    'D' => [0, +1]
  }
  movimento = movimentos[direcao]
  heroi[0] += movimento[0]
  heroi[1] += movimento[1]

  heroi
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

def posicoes_validas_a_partir_de(mapa, novo_mapa, posicao)
  posicoes = []
  cima = [posicao[0] + 1, posicao[1]]
  if posicao_valida?( mapa, cima) && posicao_valida?(novo_mapa, cima)
    posicoes << cima
  end
  direita = [posicao[0], posicao[1] + 1]
  if posicao_valida?(mapa, direita) && posicao_valida?(novo_mapa, direita)
    posicoes << direita
  end
  baixo = [posicao[0] - 1, posicao[1]]
  if posicao_valida?(mapa, baixo) && posicao_valida?(novo_mapa, baixo)
    posicoes << baixo
  end
  esquerda = [posicao[0], posicao[1] - 1]
  if posicao_valida?(mapa, esquerda) && posicao_valida?(novo_mapa, esquerda)
    posicoes << esquerda
  end

  posicoes
end

def move_fantasma(mapa, novo_mapa, linha, coluna)
  posicoes = posicoes_validas_a_partir_de mapa, novo_mapa, [linha, coluna]

  return if posicoes.empty?

  posicao = posicoes[0]
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

def joga(nome)
  mapa = le_mapa 2

  while true
    desenha mapa
    direcao = pede_movimento
    heroi = encontra_jogador mapa

    nova_posicao = calcula_nova_posicao heroi, direcao

    next if !posicao_valida? mapa, nova_posicao

    mapa[heroi[0]][heroi[1]] = ' '
    mapa[nova_posicao[0]][nova_posicao[1]] = 'H'

    mapa = move_fantasmas mapa
  end

end

def inicia_fogefoge
  nome = da_boas_vindas
  joga nome
end