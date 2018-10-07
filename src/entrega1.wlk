object rolando {

	var property valorBaseDeLucha = 1
	var property hechizoPreferido = espectroMalefico
	const property artefactos = #{}
	
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

	method filtrarArtefactos(_artefacto) = artefactos.filter{ artefacto => artefacto !== _artefacto }
	
	method mejorPertenencia(objeto) = objeto.max({ artefacto => artefacto.puntosDeLucha() }) 
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

	method esPoderoso() = nombre.size() > 15

}

object hechizoBasico {

	method poder() = 10

	method esPoderoso() = false

}

// Artefactos
object espadaDelDestino {

	var property puntosDeLucha = 3

}

object collarDivino {

	var property cantidadDePerlas = 5

	method puntosDeLucha() = cantidadDePerlas

}

object mascaraOscura {

	method puntosDeLucha() = if (fuerzaOscura.valor() <= 8) 4 else (fuerzaOscura.valor() / 2)

}

// Artefactos Lucha Avanzada
object armadura {

	var property refuerzo = object {
		method valorDelRefuerzo() = 0
	}

	method puntosDeLucha() = 2 + refuerzo.valorDelRefuerzo()

}

object espejo {
	
	var property duenio = rolando
	var artefactosSinEspejo

	method puntosDeLucha() {
		if (rolando.artefactos() == #{ self }) {
			return 0
		} else {
			artefactosSinEspejo = duenio.filtrarArtefactos(self)
			return duenio.mejorPertenencia(artefactosSinEspejo).puntosDeLucha()
		}
	}

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

	method valorDelRefuerzo() = duenio.nivelDeHechiceria()

}

object hechizo {

	var property hechizoDeRefuerzo = object {
		method poder() = 0
	}

	method valorDelRefuerzo() = hechizoDeRefuerzo.poder()

}

