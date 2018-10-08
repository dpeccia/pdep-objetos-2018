class Personaje {

	var property valorBaseDeLucha = 1
	var property hechizoPreferido
	const property artefactos = #{}
	var property monedasOro = 10

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

object hechizoBasico {

	const property precio = 10

	method poder() = 10

	method esPoderoso() = false

}

class HechizoDeLogos {

	var property precio = self.poder()
	var property nombre = ''

	method poder() = nombre.size() * new Range(1, 10).anyOne()

	method esPoderoso() = self.poder() > 15

}

// Artefactos
class Arma {
	
	var property precio = 5 * self.puntosDeLucha()
	var property puntosDeLucha = 3

}

object collarDivino {

	var property cantidadDePerlas = 0
	var property precio = 2 * cantidadDePerlas

	method puntosDeLucha() = cantidadDePerlas

}

class Mascara {
	
	var property indiceDeOscuridad = 0
	var property poderMinimo = 4

	method puntosDeLucha() = if ((fuerzaOscura.valor() / 2) * indiceDeOscuridad <= 4) poderMinimo else (fuerzaOscura.valor() / 2 * indiceDeOscuridad)

}

// Artefactos Lucha Avanzada
class Armadura {

	var property refuerzo = ningunRefuerzo

	method precio() = refuerzo.precio()
	method puntosDeLucha(valorBase) = valorBase + refuerzo.valorDelRefuerzo()
	//en el caso de la bendicion no se el dueño, que mandamos?!

}

object espejo {

	var property duenio
	var artefactosSinEspejo

	method puntosDeLucha() {
		if (duenio.artefactos() == #{ self }) {
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
class CotaDeMalla {

	var property refuerzo = 0

	method valorDelRefuerzo(duenio) = refuerzo

}

object bendicion {

	method valorDelRefuerzo(duenio) = duenio.nivelDeHechiceria()

}

object hechizo {

	var property hechizoDeRefuerzo = object {
		method poder() = 0
	}

	method valorDelRefuerzo(duenio) = hechizoDeRefuerzo.poder()

}

object ningunRefuerzo {
	const property precio = 0
	method valorDelRefuerzo(duenio) = 0
}
