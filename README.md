# series-FUNCEME

Este repositório contém códigos para pré-processamento de dados de postos pluviométricos da Fundação Cearense de Meteorologia (FUNCEME) para análise de séries temporais em linguagem R.

O objetivo é automatizar o tratamento dos dados da FUNCEME em linguagem R, como alternativa ao tratamento dos dados de forma manual usando *softwares* de planilha.
Este projeto foi desenvolvido durante o meu Mestrado em Desenvolvimento Regional Sustentável (PRODER) da Universidade Federal do Cariri (UFCA).

As séries históricas de precipitação pluviométrica da FUNCEME são armazenadas em arquivos de texto que podem ser obtidos dos endereços:

- http://www.funceme.br/?page_id=2694
- http://www.funceme.br/produtos/script/chuvas/Download_de_series_historicas/DownloadChuvasPublico.php

A função [import_FUNCEME.R](importFUNCEME.R) importa, limpa e organiza os dados para análise de séries temporais a partir de um arquivo de texto, e retorna:

- Tabelas com as séries históricas diárias e mensais no formato 'data.frame'
- Séries temporais diárias e mensais no formato 'ts'
- Coordenadas geográficas do posto pluviométrico

## Instalação

Faça download do código-fonte e utilize a função [import_FUNCEME.R](importFUNCEME.R).

## Exemplo

```
caminho <- './dados/1.csv'
posto <- import_FUNCEME(caminho)
```

## Requisitos

Escrito usando R 4.1.2, dplyr 1.0.7 e tidyr 1.1.4.

## Citação

```
@article{,
  title = {Simulação de valores ausentes em séries temporais de precipitação para avaliação de métodos de imputação},
  author = {da Cunha Júnior, Rubens Oliveira and Firmino, Paulo Renato Alves},
  journal = {Revista Brasileira de Climatologia},
  volume = {30},
  number = {18},
  pages = {691--714},
  year = {2022},
  doi = {10.55761/abclima.v30i18.15243},
  url = {https://ojs.ufgd.edu.br/index.php/rbclima/article/view/15243}
}
```

## Referências
<a id="1"></a> 
CUNHA JÚNIOR, R. O.; FIRMINO, P. R. A. 
Simulação de valores ausentes em séries temporais de precipitação para avaliação de métodos de imputação. 
**Revista Brasileira de Climatologia**,
v. 30, n. 18, p. 691-714, 2022.
Disponível em: https://ojs.ufgd.edu.br/index.php/rbclima/article/view/15243.
