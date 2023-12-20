# amt

Anima Master Toolkit

## Funcionalidades
- Carga de personajes desde JSON de planilla
- Posibilidad de cargar NPC
- Añadidos NPC de ejemplo
- Control de vida de los personajes
- Cálculo del turno de los personajes
- Muestra de habilidades secundarias e info del personaje
- Toma en cuenta si es parada o esquiva
- Toma en cuenta la sorpresa de un personaje a otro
- Toma en cuenta la cantidad de defensas que tuvo un personaje en la ronda
- Añadidos modificadores de acciónes
- Añadido botón rápido de cansancio
- Ahora se puede usar la planilla sin los personajes cargados
- Calculo del resultado de la contienda
- Calculo del resultado de un crítico
- Botón de acceso rápido a la restauración de consumibles (vida, ki, cansancio, etc)
- Vista del detalle del estado de un personaje (al atacar o defender)
- Persistencia de los personajes en partida y del estado de los mismos
- Selección y Edición de armas de los personajes
- Adición de modificadores personalizados
- Carga o generación de tiradas
- Uso del tipo de armadura específico para el tipo de ataque dado

### Proximas tareas:
- Añadir modificadores de apuntado
- Soporte a modificación/edición de armaduras
- Tomar en cuenta la localización de armadura si posee un modificador de apuntado
- Añadir modificadores de cansancio (no se aplicarán automaticamente)


### Feedback Testing:
- Al restaurar consumibles y luego recargar la pagina la vida de los personajes que no fueron modificados vuelve al estado anterior. Por ejemplo si aplico daño o modifico la vida del personaje desde la tarjeta central, tampoco se soluciona al restaurar consumibles y tirar iniciativa nuevamente.

### Realizados:
- No se puede aplicar el daño si es menor o igual a 10, si es por una especificación del sistema seria recomendable cambiar el mensaje de “daño causado: 10” por uno descriptivo de “no causa daño” o “no aplica daño”(yo pensaba que esto solo ocurría si la diferencia de ataque era menor que 10 )
- En la tarjeta del atacante en el campo daño base falta el botón de limpiar campo
- El botón para descartar los personajes atacante y defensor pasan muy desapercibidos no son claros en su funcionamiento, en cambio seria mas intuitivo agregar en la equina superior derecha de las tarjetas centrales de atacante y defensor una “X”
- Sin ningún personaje seleccionado tanto como atacante o defensor el botón de descartar personaje aparentemente no hace nada, se podría reemplazar su funcionalidad por la de limpiar los campos de la tarjeta, al igual que lo hace el mismo icono en el campo armadura en la tarjeta del defensor.
- En la sección de añadir NPC la alerta de borrar todos los NPC es poco clara, se podria cambiar por “’¿seguro que desea borrar todos los NPC de la lista de personajes activos?”
- se pueden subir personajes que ya estan cargados, cuentan como personajes diferentes, pero mantiene el mismo nombre, seria bueno agregar un numero o diferenciador al igual que cuando se cargan varios npc
- Cambiar el formato de resultado critico para usar ExplainedText
- El modal de atributos/Habilidades no se cierra al hacer clic fuera del modal.

### Descartados:
#### Se descarta porque el sector está preparado para multiples tarjetas de "consumibles". 
- En la tarjeta central tanto el atacante como defensor tienen las secciones de vida y cansancios en una columna a la izquierda dejando un gran espacio vacio. 

#### Es el comportamiento esperado, el que no admite crítico es el de critico.
- las tiradas de resistencia fisica toman el critico. 

#### Es preferible dejar a criterio del director como usarlo. Pudiendo el director definir si deja usar más cansancio (más allá de los limites normales por ej).
- con un personaje cargado se puede agregar cansancio de forma indefinida. 

