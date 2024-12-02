import jakarta.servlet.http.*;
import java.io.*;
import java.rmi.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class insert extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://127.0.0.1/encuesta"; 
    private static final String DB_USER = "angel";
    private static final String DB_PASSWORD = "123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServerException, IOException {

        PrintWriter out = response.getWriter();
        try {
            response.setContentType("text/html");
            HttpSession sesion= request.getSession(true);
            
            String pregunta = request.getParameter("pregunta");
            String estado = request.getParameter("estado");
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

            //paso 3
            String query ="INSERT INTO preguntas (pregunta, estado) VALUES (?, ?) RETURNING id";
            String queryP="INSERT INTO opciones_respuesta (pregunta_id, opcion) VALUES (?, ?)";

           // out.println("<br>"+query);
            //paso 4
            PreparedStatement psPregunta = conexion.prepareStatement(query);
            psPregunta.setString(1, pregunta);
            psPregunta.setString(2, estado);
            ResultSet rs = psPregunta.executeQuery();
            rs.next();
            int preguntaId = rs.getInt("id");
            

            PreparedStatement psOpciones = conexion.prepareStatement(queryP);
            for (String opcion : opciones) {
                psOpciones.setInt(1, preguntaId);
                psOpciones.setString(2, opcion);
                psOpciones.addBatch();
            }
            psOpciones.executeBatch();
            //paso 5

            //paso 6
            response.sendRedirect("/encuesta/src/panel.jsp");
            psPregunta.close();
            psOpciones.close();
            rs.close();
            conexion.close();


        } catch (Exception e) {
            out.println("Ocurrio un error en main:" +e);

        }

    }
}