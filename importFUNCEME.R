#' @Title
#' Pré-processamento de dados de postos pluviométricos da FUNCEME
#' 
#' @description 
#' Limpa e trata os dados obtidos do portal da Fundação Cearense de
#' Meteorologia (FUNCEME) para análise de séries temporais.
#' 
#' @param file string informando o caminho para o arquivo baixado
#' do portal FUNCEME
#'
#' @return `list` contendo séries históricas diárias e mensais no formato
#' `data.frame` e `ts`, e coordenafas geográficas do posto pluviométrico.
#'
#' @author Rubens Oliveira da Cunha Júnior (cunhajunior.rubens@gmail.com).
#' 
#' @examples
#' caminho <- './dados/1.csv'
#' posto <- import_FUNCEME(caminho)
import_FUNCEME <- function(arquivo) {
  # carrega pacotes
  require("dplyr")
  require("tidyr")
  
  # importa arquivo
  x <- read.csv2(arquivo, encoding = "latin1", sep = ";")
  n <- nrow(x)
  
  # pega coordenadas
  lat <- as.numeric(unique(x$Latitude))
  lon <- as.numeric(unique(x$Longitude))
  
  # dados mensais
  x.m <- data.frame(cbind(Ano = x$Anos, Mes = x$Meses, Precip = x$Total))
  
  dti <- as.Date(paste0(x.m$Ano[1], "/", x.m$Mes[1], "/1"))
  dtf <- as.Date(paste0(x.m$Ano[n], "/", x.m$Mes[n], "/1"))
  dt <- seq(dti, dtf, by = "month")
  
  if(length(dt)!=n) {
    # meses sem registros recebem NA
    x.m <- x.m %>% mutate(Data = as.Date(paste0(Ano, "/", Mes, "/1")), .before = Precip)
    x.f <- data.frame(Data = dt)
    x.f <- x.f %>% mutate(Ano = as.numeric(format(Data, "%Y")), Mes = as.numeric(format(Data, "%m")))
    x.f <- left_join(x.f, x.m, by = c("Data"="Data"))
    x.f <- x.f[,-c(1,4,5)]
    names(x.f) <- c("Ano", "Mes", "Precip")
  } else {
    x.f <- x.m
  }
  
  # serie mensal
  s.m <- ts(as.numeric(x.f$Precip),
            start = c(x.f$Ano[1], x.f$Mes[1]),
            end = c(x.f$Ano[nrow(x.f)], x.f$Mes[nrow(x.f)]),
            frequency = 12)
  
  # dados diarios
  # converte para o formato de dados longitudinal
  x.d <- tidyr::gather(x[,-c(1,2,3,4,7)], dia, precip, Dia1:Dia31)
  
  # formata tabela
  names(x.d) <- c("Ano", "Mes", "Dia", "Precip")
  x.d <- x.d %>% mutate(Dia = as.numeric(substr(Dia, 4, 5)))
  x.d <- x.d %>% mutate(Mes = as.numeric(Mes))
  x.d <- x.d %>% mutate(Ano = as.numeric(Ano))
  x.d <- x.d %>% arrange(Ano,Mes)
  x.d <- x.d %>% mutate(Data = paste0(sprintf("%02d", as.numeric(Dia)),"/",sprintf("%02d", as.numeric(Mes)),"/",Ano), .before = Ano)
  x.d <- x.d %>% mutate(Data = as.Date(Data, "%d/%m/%Y"))
  x.d <- x.d[!(x.d$Precip == "888.0"),]
  x.d$Precip[x.d$Precip == "999.0"] <- NA
  x.d <- x.d %>% mutate(Precip = as.numeric(Precip))
  x.d <- head(x.d, max(which(!is.na(x.d$Precip))))
  
  # serie diaria
  s.d <- ts(as.numeric(x.d$Precip),
            start = c(x.d$Ano[1], x.d$Dia[1]),
            end = c(x.d$Ano[nrow(x.d)], x.d$Dia[nrow(x.d)]),
            frequency = 365)
  
  return(list(dados.Mes = x.f,
              dados.Dia = x.d,
              serie.Mes = s.m,
              serie.Dia = s.d,
              latitude = lat,
              longitude = lon))
}