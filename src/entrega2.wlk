class Personaje {

	var property valorBaseDeLucha = 1
	var property hechizoPreferido = hechizoBasico
	const property artefactos = #{}
	var property monedasOro = 100
	var capacidadCarga

	constructor(_capacidadCarga) {
		capacidadCarga = _capacidadCarga
	}

	method capacidadCarga() = capacidadCarga

	method hechizoPreferido(hechizo) {
		var precio = hechizo.precio()
		precio -= hechizoPreferido.precio() / 2
		if (precio > 0) {
			self.pagar(precio)
		// cobrarle al personaje el precio restante
		}
		hechizoPreferido = hechizo
	}

	method nivelDeHechiceria() = (3 * hechizoPreferido.poder()) + fuerzaOscura.valor()

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method agregarArtefacto(artefacto) {
		self.validarArtefacto(artefacto)
		capacidadCarga -= artefacto.pesoTotal(self)
		self.pagar(artefacto.precio())
		artefactos.add(artefacto)
	}

	method eliminarArtefacto(artefacto) {
		capacidadCarga += artefacto.pesoTotal(self)
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
		self.validarPrecio(precio)
		monedasOro -= precio
	}

	method validarPrecio(precio) {
		if (monedasOro < precio) {
			throw new Exception("No alcanzan las monedas porque sale " + precio + " pero solo tiene " + monedasOro)
		}
	}

	method validarArtefacto(artefacto) {
		if (capacidadCarga < artefacto.pesoTotal(self)) {
			throw new Exception("La capacidad de carga (" + capacidadCarga + ") es menor al peso del artefacto (" + artefacto.pesoTotal() + ").")
		}
	}

}

class NPC inherits Personaje {

	var property nivel
	
	override method habilidadDeLucha() = super() * nivel.valor()

}

class Nivel {

	var property valor

	constructor(_valor) {
		self.valor(_valor)
	}

}

object facil {

	method valor() = 1

}

object moderado {

	method valor() = 2

}

object dificil {

	method valor() = 4

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

	method precio() = self.poder()

	method poder() = nombre.size() * new Range(1, 10).anyOne()

	method esPoderoso() = self.poder() > 15

}

class HechizoDeLogosPrueba {

	var property nombre = ''

	method precio() = self.poder()

	method poder() = nombre.size() * 1

	method esPoderoso() = self.poder() > 15

}

object hechizoComercial {

	var property nombre = ''
	var property porcentaje = 0.2
	var property multiplicador = 2

	method poder() = nombre.size() * porcentaje * multiplicador

	method esPoderoso() = self.poder() > 15

}

// Artefactos
class Arma inherits Artefacto {

	var property puntosDeLucha = 3

	method precio() = 5 * puntosDeLucha

	method puntosDeLucha(duenio) = puntosDeLucha

}

object collarDivino inherits Artefacto {

	var property cantidadDePerlas = 0

	override method pesoTotal(duenio) = super(duenio) + 0.5 * cantidadDePerlas

	method precio() = 2 * cantidadDePerlas

	method puntosDeLucha(duenio) = cantidadDePerlas

}

class Mascara inherits Artefacto {

	var property indiceDeOscuridad = 0
	var property poderMinimo = 4

	override method pesoTotal(duenio) = super(duenio) + 0.max(self.puntosDeLucha(duenio) - 3)

	method precio() = 0

	method puntosDeLucha(duenio) = poderMinimo.max((fuerzaOscura.valor() / 2) * indiceDeOscuridad)

}

class Artefacto {

	var property fechaDeCompra = new Date()
	var property peso = 0

	method diasDesdeCompra() = new Date() - fechaDeCompra

	method pesoTotal(duenio) = 0.max(peso - self.factorDeCorreccion())

	method factorDeCorreccion() = 1.min(self.diasDesdeCompra() / 100)

}

// Artefactos Lucha Avanzada
class Armadura inherits Artefacto {

	var property refuerzo = ningunRefuerzo
	var property valorBase = 3

	override method pesoTotal(duenio) = super(duenio) + refuerzo.peso()

	method precio() = refuerzo.precio(self)

	method puntosDeLucha(duenio) = valorBase + refuerzo.valorDelRefuerzo(duenio)

}

object espejo inherits Artefacto {

	method precio() = 90

	method puntosDeLucha(duenio) {
		var artefactosSinEspejo
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

	method peso() = 1

	method precio(armadura) = refuerzo / 2

	method valorDelRefuerzo(duenio) = refuerzo

}

object bendicion {

	method peso() = 0

	method precio(armadura) = armadura.valorBase()

	method valorDelRefuerzo(duenio) = duenio.nivelDeHechiceria()

}

class Hechizo {

	var property hechizoDeRefuerzo = object {
		method poder() = 0
		method precio() = 0
	}

	method peso() = if (hechizoDeRefuerzo.poder().even()) 2 else 1

	method precio(armadura) = armadura.valorBase() + hechizoDeRefuerzo.precio()

	method valorDelRefuerzo(duenio) = hechizoDeRefuerzo.poder()

}

object ningunRefuerzo {

	method peso() = 0

	method precio(armadura) = 2

	method valorDelRefuerzo(duenio) = 0

}

