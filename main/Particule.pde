class Particule
{
  //Accesseurs pour l'attribut InverseMasse
  
  Vector3D position = new Vector3D(0,0,0);
  Vector3D linearVelocity = new Vector3D(0,0,0);
   
  float mass = 0;

  Particule(float mass){
    this.mass = mass;
    this.position = new Vector3D(0,0,0);
    this.linearVelocity = new Vector3D(0,0,0);
  }
  
  Particule(float mass, Vector3D position){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = new Vector3D(0,0,0);
  }
  
  Particule(float mass, Vector3D position, Vector3D linearVelocity){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
  }
  
  float InverseMass() {
    return 1 / mass;
  }
  
  //Intégrateur pour update pos et vel de Particule (Euler ou Verlet ou les 2 qu'on pourrait switch manuellement)
  //prendre en compte damping
  
  
  
}
