import jakarta.servlet.http.*;
import java.io.*;
import java.rmi.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class update extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://127.0.0.1/encuesta"; 
    private static final String DB_USER = "angel";
    private static final String DB_PASSWORD = "123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServerException, IOException {

        PrintWriter out = response.getWriter();
        try {
            response.setContentType("text/html");
            HttpSession sesion= request.getSession(true);
            int pregunta_id= Integer.parseInt(request.getParameter("id"));
            String pregunta = request.getParameter("pregunta");
            String[] opciones = {
                request.getParameter("opcion1"),
                request.getParameter("opcion2"),
                request.getParameter("opcion3"),
                request.getParameter("opcion4"),
                request.getParameter("opcion5")
            };
/*
        out.println("<br>Correo: " + correo);
        out.println("<br>Contraseña: " + contrasena);
        out.println("<br>Número de control: " + nControl);
        out.println("<br>Nombre: " + firstname + " " + lastname);
        out.println("<br>Fecha de nacimiento: " + nacimiento);
        out.println("<br>Edad: " + edad);
        out.println("<br>Género: " + genero);
        out.println("<br>Correo personal: " + correoPersonal);
        out.println("<br>Correo alternativo: " + correoAlternativo);
        out.println("<br>Teléfono: " + telefono);
        out.println("<br>Nombre del tutor: " + nombreTutor);
        out.println("<br>Teléfono del tutor: " + telefonoTutor);
        out.println("<br>Calle: " + calle);
        out.println("<br>Colonia: " + colonia);
        out.println("<br>Código Postal: " + codigoPostal);
        out.println("<br>Ciudad: " + ciudad);
        out.println("<br>Estado: " + estado);


        if (becasSeleccionadas != null) {
            out.println("<br>Becas seleccionadas: ");
            for (String beca : becasSeleccionadas) {
                out.println(beca + " ");
           }
        } else {
            out.println("<br>No se seleccionaron becas.");
        }


        out.println("<br>Programa seleccionado: " + programaSeleccionado);


        if (especificaBeca != null && !especificaBeca.isEmpty()) {
            out.println("<br>Especifica Beca: " + especificaBeca);
        }


        out.println("<br>Comentarios: " + comentarios);
*/ 
            //paso 1
   //         out.println("<br>Inicio<br>");
            Class.forName("org.postgresql.Driver");
     //       out.println("<br>Driver registrado<br>");

            //paso 2
       //     out.println("Conectando a ...."+DB_URL);
            Connection conexion= DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
         //   out.println("<br>Conexion (sesion)lista");

               // Consulta para actualizar la pregunta
        String query = "UPDATE preguntas SET pregunta = ? WHERE id = ? RETURNING id";

        // Consulta para actualizar las opciones de respuesta
        String queryP = "UPDATE opciones_respuesta SET opcion = ? WHERE id = ?";

        // Paso 4: Actualizar la pregunta
        PreparedStatement psPregunta = conexion.prepareStatement(query);
        psPregunta.setString(1, pregunta);
        psPregunta.setInt(2, pregunta_id);
        ResultSet rsPregunta = psPregunta.executeQuery();
        rsPregunta.next();

        // Obtener los IDs de las opciones de respuesta para esta pregunta
        String selectQuery = "SELECT id FROM opciones_respuesta WHERE pregunta_id = ?";
        PreparedStatement psSelect = conexion.prepareStatement(selectQuery);
        psSelect.setInt(1, pregunta_id);
        ResultSet rs = psSelect.executeQuery();

        List<Integer> opcionIds = new ArrayList<>();
        while (rs.next()) {
            opcionIds.add(rs.getInt("id"));
        }

        // Asegúrate de que el número de opciones coincida con el número de IDs
        if (opcionIds.size() != opciones.length) {
            throw new IllegalStateException("El número de opciones no coincide con el número de IDs.");
        }

        // Actualizar las opciones una por una
        PreparedStatement psOpciones = conexion.prepareStatement(queryP);
        for (int i = 0; i < opciones.length; i++) {
            psOpciones.setString(1, opciones[i]); // Establece el valor de la nueva opción
            psOpciones.setInt(2, opcionIds.get(i)); // Establece el ID correspondiente
            psOpciones.addBatch(); // Agrega la actualización al batch
        }
        psOpciones.executeBatch(); // Ejecuta todas las actualizaciones
        response.sendRedirect("/encuesta/src/panel.jsp");

        // Cerrar recursos
        psPregunta.close();
        psSelect.close();
        psOpciones.close();
        rs.close();
        rsPregunta.close();
        conexion.close();


            //paso 5

            //paso 6
            

        } catch (Exception e) {
            out.println("Ocurrio un error en main:" +e);

        }

    }
}