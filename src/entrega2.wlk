class Personaje {

	var property valorBaseDeLucha = 1
	var property hechizoPreferido = hechizoBasico
	const property artefactos = #{}
	var property monedasOro = 100

	method hechizoPreferido(hechizo) {
		feriaHechiceria.obtenerNuevoHechizo(self, hechizo)
		hechizoPreferido = hechizo
	}

	method nivelDeHechiceria() = (3 * hechizoPreferido.poder()) + fuerzaOscura.valor()

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method agregarArtefacto(artefacto) {
		feriaHechiceria.obtenerArtefacto(self, artefacto)
		artefactos.add(artefacto)
	}

	method eliminarArtefacto(artefacto) {
		artefactos.remove(artefacto)
	}

	method habilidadDeLucha() = valorBaseDeLucha + artefactos.sum({ artefacto => artefacto.puntosDeLucha(self) })

	method estaCargado() = artefactos.size() >= 5

	method tieneMayorLucha() = self.habilidadDeLucha() > self.nivelDeHechiceria()

	method filtrarArtefactos(_artefacto) = artefactos.filter{ artefacto => artefacto !== _artefacto }

	method mejorPertenencia(objeto) = objeto.max({ artefacto => artefacto.puntosDeLucha(self) })
	
	method cumplirObjetivo() {
		monedasOro += 10
	}
	
	method pagar(precio) {
		if(monedasOro < precio) {
			throw new Exception("No alcanzan las monedas porque sale " + precio + " pero solo tiene " + monedasOro)
		}
		monedasOro -= precio
	}

}

object fuerzaOscura {

	var property valor = 5
	
	method hacerEclipse() {
		valor = valor * 2
	}

}

// Hechizos

object hechizoBasico {

	method precio() = 10

	method poder() = 10

	method esPoderoso() = false

}

class HechizoDeLogos {

	var property nombre = ''
	var property numeroAlAzar = new Range(1, 10).anyOne()


	method precio() = self.poder()
	method poder() = nombre.size() * numeroAlAzar
	method esPoderoso() = self.poder() > 15

}

// Artefactos
class Arma {
	
	var property puntosDeLucha = 3
	
	method precio() = 5 * puntosDeLucha
	method puntosDeLucha(duenio) = self.puntosDeLucha()
	//no hay una manera mejor de hacer esto?
}

object collarDivino {

	var property cantidadDePerlas = 0
	method precio() = 2 * cantidadDePerlas

	method puntosDeLucha(duenio) = cantidadDePerlas

}

class Mascara {
	
	var property indiceDeOscuridad = 0
	var property poderMinimo = 4

	method puntosDeLucha(duenio) = poderMinimo.max((fuerzaOscura.valor()/2) * indiceDeOscuridad)
}

// Artefactos Lucha Avanzada
class Armadura {

	var property refuerzo = ningunRefuerzo
	var property valorBase = 0

	method precio() = refuerzo.precio()
	method puntosDeLucha(duenio) = valorBase + refuerzo.valorDelRefuerzo(duenio)

}

object espejo {

	var artefactosSinEspejo

	method precio() = 90
	method puntosDeLucha(duenio) {
		if (duenio.artefactos() === #{ self }) {
			return 0
		} else {
			artefactosSinEspejo = duenio.filtrarArtefactos(self)
			return duenio.mejorPertenencia(artefactosSinEspejo).puntosDeLucha(duenio)
		}
	}

}

object libroDeHechizos {

	const hechizos = #{}

	method precio() = 10 * hechizos.size() + self.hechizosPoderosos().sum({ hechizo => hechizo.poder() })

	method agregarHechizo(hechizo) {
		hechizos.add(hechizo)
	}
	
	method hechizosPoderosos() = hechizos.filter({ hechizo => hechizo.esPoderoso() })

	method poder() = self.hechizosPoderosos().sum({ hechizo => hechizo.poder() })

// si el libro de hechizos se tiene como libro de hechizos a si mismo
// entra en una recursiva infinita por no tener caso base
}

//refuerzos
class CotaDeMalla {

	var property refuerzo = 0

	method precio(armadura) = refuerzo/2
	method valorDelRefuerzo(duenio) = refuerzo

}

object bendicion {
	
	method precio(armadura) = armadura.valorBase()

	method valorDelRefuerzo(duenio) = duenio.nivelDeHechiceria()

}

class Hechizo {

	var property hechizoDeRefuerzo = object {
		method poder() = 0
		method precio(armadura) = 0
	}
	
	method precio(armadura) = armadura.valorBase() + hechizoDeRefuerzo.precio(armadura)

	method valorDelRefuerzo(duenio) = hechizoDeRefuerzo.poder()

}

object ningunRefuerzo {
	method precio(armadura) = 2
	method valorDelRefuerzo(duenio) = 0
}

object feriaHechiceria {
	method obtenerNuevoHechizo(personaje, hechizo) {
		var precio = hechizo.precio()
		precio -= personaje.hechizoPreferido().precio()/2
		if (precio > 0){
			personaje.pagar(precio)
			//cobrarle al personaje el precio restante
		}
		personaje.hechizoPreferido(hechizo)
	}
	method obtenerArtefacto(personaje, artefacto) {
		personaje.pagar(artefacto.precio())
	}
}

