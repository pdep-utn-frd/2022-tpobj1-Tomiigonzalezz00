import wollok.game.*
    


object juego{
	const velocidad = 170

	method configurar(){
		 
		game.width(15)
		game.height(12)
		game.title("Dino Game")
		game.boardGround("Fondo.png")
		game.addVisual(valla)
		game.addVisual(atleta)
		game.addVisual(reloj)
		game.addVisual(puntaje)
	
		

	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(atleta,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	
	method  iniciar(){
		atleta.iniciar()
		reloj.iniciar()
		valla.iniciar()
		agua.iniciar()
		puntaje.iniciar()
	}
	
	method rapidez(){
		return velocidad
	}
	
	method jugar(){
		if (atleta.estaVivo()) 
			atleta.saltar()
		else {
			game.removeVisual(gameOver)
			game.removeVisual(restart)
			game.removeVisual(maximo)
			game.removeVisual(actual)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		game.addVisual(restart)
		maximo.puntuacionmaxima()
		game.addVisual(maximo)
		game.addVisual(actual)
		valla.detener()
		reloj.detener()
		atleta.morir()
		agua.detener()	
		
	}
}

	

object gameOver {
	method position() = game.at(game.width()-23 , game.height()-15)
	method image() = "gameover.jpg"
	}
	
object restart{
	method text()="PRESS SPACE TO RESTART"
	method textColor()= color.blanco()
	method position() = game.at(game.center().x(), game.height()-10)
}
	
object maximo{
		var puntosmax=0
		method puntuacionmaxima(){
			if(puntaje.total() > puntosmax)
			puntosmax = puntaje.total()
		} 
	
	method text()="HIGHSCORE:" + puntosmax.toString()
	method textColor()= color.rojo()
	method position() = game.at(game.center().x()-2, game.height()-11)
	}
	
	
	
object puntaje{
	var puntos 
	method text() =  "SCORE: "+ puntos.toString()
	method position() = game.at(game.width()-2, game.height()-1)
	method textColor()= color.rojo()
	method cuenta(){
		puntos = puntos+1
	}
	
	method total(){
		return puntos
	}
	method iniciar(){
		puntos=-1
		self.cuenta()
	}
}

object actual{
	method text() =  "YOUR SCORE: "+ puntaje.total().toString()
	method position() = game.at(game.center().x()+2, game.height()-11)
	method textColor()= color.rojo()
}
	
object color {
	const property rojo = "FF0000FF"
	const property blanco = "FFFFFFFF"
	
}



object reloj {
	
	var tiempo 
	
	method text() = "TIME: " + tiempo.toString()
	method position() = game.at(1, game.height()-1)
	method textColor()= color.rojo()
	
	method pasarTiempo() {
		tiempo = tiempo +1

	}
	method iniciar(){
		tiempo = 0
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
	

}
object valla {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "valla.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(juego.rapidez(),"moverValla",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverValla")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
}


object atleta {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	
	method image() = "atleta1.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(juego.rapidez()*2,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}


object agua{
	var aparece 

	const posicionInicial = game.at(game.width()-3,suelo.position().y()+1)
	var position = posicionInicial
	method image() = "agua.png"
	method position() = position
	
	
	method iniciar(){
		game.addVisual(self)
		position = posicionInicial
		game.onTick(3000,"aparece",{self.aparecer()})
		game.onTick(juego.rapidez(),"moverAgua",{self.mover()})
		aparece=true
	}
	
	method aparecer(){
			if(not aparece){
 			game.addVisual(self)
 			aparece=true
 			}	
	}

	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
     }
     
      
     	
	method detener(){
		game.removeTickEvent("moverAgua")
		if(aparece)
		game.removeVisual(self) 
		game.removeTickEvent("aparece")
	}
	
	
	method chocar(){
		game.removeVisual(self)	
		aparece=false
		puntaje.cuenta()
		}
  }
