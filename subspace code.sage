import pickle
f = open("field2^1000.fld")
field = pickle.load(f)
f.close()
R.<t> = PolynomialRing(field)
R1.<y> = PolynomialRing(field)
def rightdiv(p1,p2):
   """Die Methode führt eine RechtsDivision für linearisierte polynome durch
    sie berrechnet also p1 = p2(q) +r wobei in out die Ergebnissse wie folgt gespeichert werden. 
	out[0] = q und out [1] = r """ 
   out = []
   pol1 = 0*t
   pol2 = 0*t
   out.append(pol1)
   out.append(pol2)
   if p1.degree() < p2.degree() :
    out[0]= 0*t
    out[1] = p1 
    return out
   d = log(p1.degree(),2)
   e = log(p2.degree(),2)
   a1 = p1.lc()
   a2 = p2.lc()
   pout = ((a1/a2)^(2^(1000-e)))*(t^(2^(d-e)))
   out[0] = pout + rightdiv(p1-(p2(pout)),p2)[0]
   out[1] = 0 + rightdiv(p1-(p2(pout)),p2)[1]
   return out 
def wdeg(p0,p1,k) :
   dt = p0.degree()
   dy = p1.degree()
   if dt == -1 :
      dt = 0
   if dy == -1 :
      dy = 0
   if dt != 0 :
      dt = log(dt,2)
   if dy != 0:
      dy = log(dy,2)
      	  
   if dt >= (dy+k-1) :
      return dt
   else :
	  return (dy+k-1) 
def interpolate(basis,a) :
   f0t = t 
   f0y = 0*y 
   f1t = 0*t 
   f1y = y
   for x in basis :
     d0 = (f0t(x[0]) + f0y(x[1]))  
     d1 = (f1t(x[0]) + f1y(x[1]))
     count = 1
     if d0 == 0 :
        f1t = (f1t^2)-(d1*f1t)
        f1y = (f1y^2)-(d1*f1y)
        
     elif d1 == 0:
        f0t = (f0t^2)-(d0*f0t)
        f0y = (f0y^2)-(d0*f0y)
     else :
        k = wdeg(f0t,f0y,a)
        l = wdeg(f1t,f1y,a)
        if k <= l :
          f1t = (d1*f0t) - (d0*f1t)
          f1y = (d1*f0y) - (d0*f1y)
          f0t = (f0t^2) - (d0*f0t)
          f0y = (f0y^2) - (d0*f0y)
          
        else :
          f0t = (d1*f0t)-(d0*f1t)
          f0y = (d1*f0y)-(d0*f1y)
          f1t = (f1t^2)-(d1*f1t)
          f1y = (f1y^2)-(d1*f1y)
         
   k = wdeg(f1t,f1y,a) 
   l = wdeg(f0t,f0y,a)
   if k < l :
    
     out = []
     out.append(f1t)
     out.append(f1y)
     return out
   else :
     
     out = [] 
     out.append(f0t)
     out.append(f0y)	  
     return out           

b = 8 # gibt den Parameter k = Anzahl der Pakete an aus der Bachelorarbeit an
poly = 0*t
for i in range(b) :
  poly = poly + field.random_element()*t^(2^i) # Hier werden die zufälligen elemente als pakete angelegt angefügt

a =[] 
for i in range(12): #durch ändern des Parameters  kann man Paketverlust simulieren
    a.append(field.fetch_int(2^(999-i)))#Hier wird die Basis A gebildet
basis = []
for x in a :
   elem = []
   elem.append(x)
   elem.append(poly(x))
   basis.append(elem)
elem=[]
elem.append(field.fetch_int(0))
elem.append(field.fetch_int(0))
basis.append(elem)#speichern der Basis so wie sei gesenedet werden würde.
qpoly = interpolate(basis,b)#Interpolieren der Basis
p1 = qpoly[0]
p2 =qpoly[1](t)
if( p2 == 0*t):
   print("Fehler")
else :
  out = rightdiv(p1,p2)
  if out[1] !=0 :
    print("Fehler2")
    print(out[0])
  if out[0] == poly :
    print("Erfolg")#vergleich ob das ursprungspolynom zurück gerechnet wurde
