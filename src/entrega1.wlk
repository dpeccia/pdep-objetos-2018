object rolando {

	var property fuerzaOscura = fuerzaOscura.valor()
	var property valorBaseDeLucha = 1
	var property hechizoPreferido = espectroMalefico
	var artefactos = #{}

	method nivelDeHechiceria() = (3 * hechizoPreferido.poder()) + fuerzaOscura

	method eclipse() {
		fuerzaOscura *= 2
	}

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method agregarArtefacto(artefacto) {
		artefactos.add(artefacto)
	}

	method eliminarArtefacto(artefacto) {
		artefactos.remove(artefacto)
	}

	method habilidadDeLucha() = valorBaseDeLucha + artefactos.sum({ artefacto => artefacto.puntosDeLucha() })

	method estaCargado() = artefactos.size() >= 5

	method tieneMayorLucha() = self.habilidadDeLucha() > self.nivelDeHechiceria()

	method mejorPertenencia() = artefactos.max({ artefacto => artefacto.puntosDeLucha() })

}

object fuerzaOscura {
	var property valor = 5
}

// Hechizos
object espectroMalefico {

	var property nombre = "Espectro malefico"

	method poder() = nombre.size()

	method esPoderoso() = nombre.size() > 15 //no hay que hacer self.poder()?

}

object hechizoBasico {

	method poder() = 10

	method esPoderoso() = false // no hay que hacer self.poder() > 15?

}

// Artefactos
//cambiar el nombre habilidad por puntosDeLucha
object espadaDelDestino {

	var property puntosDeLucha = 3

}

object collarDivino {

	var property cantidadDePerlas = 10

	method puntosDeLucha() = cantidadDePerlas

}

object mascaraOscura {

	method puntosDeLucha() = if (rolando.fuerzaOscura() < 10) 4 else (rolando.fuerzaOscura() / 2)

}

// Artefactos Lucha Avanzada
object armadura {

	var property refuerzo // inicializar

	method puntosDeLucha() = 2 + refuerzo.valorDelRefuerzo()

	// consultar que pasaría si no hay ningun refuerzo
	
}

object espejo {

	method puntosDeLucha() = rolando.mejorPertenencia()

}

object libroDeHechizos {

	const hechizos = #{}

	method poder() = hechizos.sum({ hechizo => hechizo.poder() })

// si el libro de hechizos se tiene como libro de hechizos a si mismo
// entra en una recursiva infinita por no tener caso base
}

//refuerzos
object cotaDeMalla {

	method valorDelRefuerzo() = 1

}

object bendicion {

	method valorDelRefuerzo() = rolando.nivelDeHechiceria() // consultar

}

object hechizo {
	
	var property hechizoDeRefuerzo = hechizoBasico
	
	method valorDelRefuerzo() = hechizoDeRefuerzo.nivelDeHechiceria()
	
}

