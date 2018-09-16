object rolando {

	var property valorBaseDeLucha = 1
	var property hechizoPreferido = espectroMalefico //esta bien que inicialice con esto?
	var artefactos = #{}

	method nivelDeHechiceria() = (3 * hechizoPreferido.poder()) + fuerzaOscura.valor()

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

	method mejorPertenencia() = artefactos.max({ artefacto => artefacto.puntosDeLucha()})

}

object eclipse {
	method ocurrir() {
		fuerzaOscura.valor(fuerzaOscura.valor() * 2)
	}
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

	method puntosDeLucha() = if (fuerzaOscura.valor() =< 8) 4 else (fuerzaOscura.valor() / 2)

}

// Artefactos Lucha Avanzada
object armadura {

	var property refuerzo = object {
		method valorDelRefuerzo() = 0
	}

	method puntosDeLucha() = 2 + refuerzo.valorDelRefuerzo()
	
}

object espejo {

	method puntosDeLucha() = rolando.mejorPertenencia()
	//esto no puede entrar en un loop infinito???

}

object libroDeHechizos {

	const hechizos = #{}

	method agregarHechizo(hechizo) {
		hechizos.add(hechizo)
	}

	method poder() = hechizos.filter({ hechizo => hechizo.esPoderoso() }).sum({ hechizo => hechizo.poder() })

// si el libro de hechizos se tiene como libro de hechizos a si mismo
// entra en una recursiva infinita por no tener caso base
}

//refuerzos
object cotaDeMalla {

	method valorDelRefuerzo() = 1

}

object bendicion {
	var property duenio = rolando

	method valorDelRefuerzo() = duenio.nivelDeHechiceria() // consultar

}

object hechizo {
	
	var property hechizoDeRefuerzo = object {
		method poder() = 0
	}
	
	method valorDelRefuerzo() = hechizoDeRefuerzo.poder() //consultar
	
}

