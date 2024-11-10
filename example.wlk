class Plato {
  const cocinero // un plato tiene un cocinero (esto es necesario para obtener el ganador del torneo)

  method cantAzucar()   // metodo abstracto
  method esBonito()     // metodo abstracto

  method cocinero() = cocinero    // el getter del cocinero del plato (lo necesito para el torneo)

  method caloriasMaximas(caloriasDeseadas) = self.calorias() <= caloriasDeseadas 

  // 1. Conocer las calorías de un plato. Las calorías de cualquier plato se calculan como 3 * la cantidad de azúcar que contiene + 100 de base.
  method calorias() = 3 * self.cantAzucar() + 100
}

class Entrada inherits Plato {
  override method cantAzucar() = 0
  override method esBonito() = true   // las entradas siempre son bonitas
}

class Principal inherits Plato {
  const cantAzucar 
  const esBonito

  override method cantAzucar() = cantAzucar   // Los principales pueden tener una cantidad de azúcar o nada, 
  override method esBonito() = esBonito       // y pueden o no ser bonitos. (POR ESO SON ATRIBUTOS)
}

class Postre inherits Plato {
  const cantColores
  
  override method cantAzucar() = 120
  override method esBonito() = cantColores > 3  // son bonitos cuando tienen más de 3 colores.
}

class Cocinero {
  // 3. Que un cocinero pueda cambiar de especialidad
  var especialidad  // un cociero tiene una especialidad y la puede cambiar 

  method cambiarEspecialidad(nuevaEspecialidad) {
    especialidad = nuevaEspecialidad
  } 

  // 2. Catar un plato. Cuando un plato es catado, se obtiene la calificación que le da el catador.
  method calificacionPara(plato) = especialidad.catar(plato)   // le paso la pelota a la especialidad...

  // 5. Hacer que un cocinero cocine, lo cual crea un plato y lo retorna.
  method cocinar() = especialidad.cocinar(self)                   // le paso la pelota a la especialidad...

}

// 3. Que un cocinero pueda cambiar de especialidad (por ejemplo, pasar de ser chef a ser pastelero).
// Por eso los hago clases

class EspecialidadPastelero {
  var nivelDeseadoDeDulzor

  method catar(plato) = (5 * plato.cantAzucar() / (nivelDeseadoDeDulzor)).min(10) // maximo 10

  // Los pasteleros crean postres con tantos colores como su nivel de dulzor deseado dividido 50.
  method cocinar(elCocinero) = new Postre(cocinero = elCocinero, cantColores = nivelDeseadoDeDulzor/50)
}

class EspecialidadChef {
  var cantCaloriasDeseada
  
  // lo tengo que divir en problemitas, para poder luego overridear el califiacionSiNoCumpleExpectativa

  method platoCumpleExpectativa(plato) = plato.esBonito() and plato.caloriasMaximas(cantCaloriasDeseada)

  method catar(plato) = if(self.platoCumpleExpectativa(plato)) 10 else self.califiacionSiNoCumpleExpectativa(plato)

  method califiacionSiNoCumpleExpectativa(plato) = 0

  // Los chefs crean platos principales bonitos con una cantidad de azúcar igual a la cantidad de calorías preferida del cocinero.
  method cocinar(elCocinero) =  new Principal(cocinero = elCocinero, esBonito = true, cantAzucar = cantCaloriasDeseada)

}

// 4. Agregar la especialidad souschef. El souschef es como el chef pero 
// cuando no se cumplen las expectativas la calificación que pone es la cantidad de calorías del plato / 100 (máximo 6).
class EspecialidadSouschef inherits EspecialidadChef {
  override method califiacionSiNoCumpleExpectativa(plato) = (plato.calorias() / 100).min(6) // maximo 6

  // Los souschefs crean entradas.
  override method cocinar(elCocinero) = new Entrada(cocinero = elCocinero)

}

class Torneo {          // Existen torneosssss
  const catadores = []  // Existen torneos, que tienen catadores.
  const platosPresentados = []

  // Hacer que un cocinero participe en un torneo: al participar cocina y presenta su plato al torneo.
  method sumarParticipacion(cocinero) {
    platosPresentados.add(cocinero.cocinar())
  }

  method ganador() {
    if(platosPresentados.isEmpty()) // si platosPresentados esta vacio, es decir, NO se presento ningun cociero al torneo, entonces lanzo una excepcion
      throw new DomainException(message = "No se puede definir el ganador de un torneo si no hay participantes")
      
      //  1ero obtengo el plato con mayor puntuacion, 2do quiero obtener el cocinero ganador de ese plato ganador
      return platosPresentados.max({plato => self.calificacionTotal(plato)}).cocinero()
  }

  // la calificacion total que obtiene un plato =  es la suma de cada una de las calificaciones otorgadas por cada catador a ese plato
  method calificacionTotal(plato) = catadores.sum({catador => catador.catar(plato)})  // califacion total que obtiene un plato

}