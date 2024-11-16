class Personaje {
  var property copas = 10

  method tieneEstrategia()
  method destreza()
  method apto() = copas >= 10

  method ganarCopas(nuevas) {
    copas += nuevas
  }

  method perderCopas(perdidas) {
    copas -= perdidas
  }
}

class Arquero inherits Personaje {
  const agilidad
  const rango

  override method tieneEstrategia() = rango > 100
  override method destreza() = agilidad * rango
}

class Ballestero inherits Arquero {
  override method destreza() = super() * 2
}

class Guerrera inherits Personaje {
  const tieneEstrategia
  const fuerza

  override method tieneEstrategia() = tieneEstrategia
  override method destreza() = fuerza * 1.5
}

class Equipo {
  const property integrantes

  method apto() = integrantes.sum({persona => persona.copas()}) >= 60
  
  method ganarCopas(nuevas) {
    integrantes.forEach({persona => persona.ganarCopas(nuevas)})
  }

  method perderCopas(perdidas) {
    integrantes.forEach({persona => persona.perderCopas(perdidas)})
  }
}

class Mision {
  const participante
  const multiplicador = comun 

  method copasIniciales()
  method cantidadParticipantes()
  method copasEnJuego() = multiplicador.sumarCopas(self)
  method puedeSuperarse()
  method realizarse() {
    if (participante.apto()) {
      if (self.puedeSuperarse())
        participante.ganarCopas(self.copasEnJuego())
      else
        participante.perderCopas(self.copasEnJuego())
    }
    else
      throw new DomainException(message = "Mision no puede comenzar")
  }
}

class MisionIndividual inherits Mision {
  const dificultad

  override method cantidadParticipantes() = 1
  override method copasIniciales() = dificultad * 2
  override method puedeSuperarse() = participante.tieneEstrategia() || participante.destreza() > dificultad
}

class MisionEquipo inherits Mision {
  override method cantidadParticipantes() = participante.integrantes().size()
  override method copasIniciales() = 50 / self.cantidadParticipantes()
  override method puedeSuperarse() = participante.integrantes().count({persona => persona.tieneEstrategia()}) > self.cantidadParticipantes() / 2 ||
                                    participante.integrantes().all({persona => persona.destreza() > 400})
}

object comun {
  method sumarCopas(mision) = mision.copasIniciales()
}

object boost {
  method sumarCopas(mision) = 3 * mision.copasIniciales()
}

object bonus {
  method sumarCopas(mision) = mision.copasIniciales() + mision.cantidadParticipantes()
}
