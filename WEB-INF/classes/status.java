import jakarta.servlet.http.*;
import java.io.*;
import java.rmi.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


public class status extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://127.0.0.1/encuesta"; 
    private static final String DB_USER = "angel";
    private static final String DB_PASSWORD = "123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServerException, IOException {

        PrintWriter out = response.getWriter();
        try {
            response.setContentType("text/html");
            HttpSession sesion= request.getSession(true);
            
            String pregunta_id = request.getParameter("id");
            String estado = request.getParameter("estado");

        
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

            //paso 3
            String query = "UPDATE preguntas SET estado = ? WHERE id = ?";

           // out.println("<br>"+query);
            //paso 4
            PreparedStatement psPregunta = conexion.prepareStatement(query);
            psPregunta.setString(1, estado);
            psPregunta.setInt(2, Integer.parseInt(pregunta_id));

            psPregunta.executeUpdate();

            response.sendRedirect(request.getHeader("Referer"));

            //paso 6
            psPregunta.close();
           
            conexion.close();


        } catch (Exception e) {
            out.println("Ocurrio un error en main:" +e);

        }

    }
}
