(thanks to Michael Evans for sending this up  --  Francisco)

The following is extracted from the /DOCS/CADDEVL.DOC file on the
CAD-3D 2.0 Developers disk. It is copyrighted by Tom Hudson, which is
why I have included the licenseing stuff.
----------------------------------------------------------------

                        Stereo CAD-3D 2.0
              Communication Pipeline Specification
                          by Tom Hudson
                           April, 1987
                    Copyright 1987 Tom Hudson
                       All rights reserved
                            FOREWORD

  CAD-3D 2.0 DEVELOPER'S DISK is provided on an unprotected
  disk because the author and Antic both believe that the buyer
  should be able to make backup copies for his or her use ONLY.
  Because it is unprotected, we expect you to respect the
  copyright and NOT give, sell or even lend copies of this
  program to anyone else.

  The author spent many hours designing, writing, developing
  and testing this product.  His income depends on its sales.
  The unauthorized reproduction of the CAD-3D 2.0 DEVELOPER'S
  DISK diskette and/or user manual is a crime. Please help us
  to protect and enforce the author's rights in this product so
  that we may continue to provide you with unprotected
  software.  For more information about these rights, please
  read the SOFTWARE ETHICS appendix at the end of this manual.
  No part of this product may be reproduced and/or distributed
  in any form or by any means without the prior written consent
  of Antic. (See LICENSING, below.)

  This is a powerful program and its potential for misuse and

                            LICENSING

  Any products developed using the CAD-3D 2.0 DEVELOPER'S DISK
  may be licensed FREE OF CHARGE through Antic Software.
  However, you must write us for an official release and
  include a description of your product, and your name,
  address, and phone number.

  We are extremely interested in your efforts and will maintain
  confidentiality in regards to your product.  We are, of
  course, also interested in marketing exciting software that
  takes advantage of CYBER STUDIO.  If you wish us to consider
  your product for marketing, please indicate this in your
  application for licensing, and include a copy of your
  software plus any necessary documentation.

  Please send your application for licensing to:


                 CAD-3D 2.0 DEVELOPMENT SOFTWARE
                 PRODUCT DEVELOPMENT DEPTARTMENT
                         ANTIC SOFTWARE
                        544 SECOND STREET
                    SAN FRANCISCO, CA  94107
                         (415) 957-0886


                    Section 5:  File Formats


  CAD-3D THREE-DIMENSIONAL OBJECT FILE

  CAD-3D 2.0 stores its 3D objects in a file which can hold up
  to 40 objects, and contains all the information about the
  objects, including the lighting and color palette used by the
  objects.

  The file is similar to the older file format, but no longer
  relies on the Motorola Fast Floating Point library (LIBF) for
  the storage of vertex coordinates.  The new version stores
  each coordinate in a two-byte word instead of a four-byte
  floating-point value, saving a considerable amount of
  storage, as well as making the file usable more easily by
  programs written with different floating-point formats.

  The CAD-3D 2.0 3D object file uses an extension of .3D2, and
  is composed of two parts.  The first section is a 256-byte
  header, which tells how many objects are included in the
  file, the light settings and the color information.  The
  second section of the file contains a repeating structure of
  data which defines the 3D objects in the file.

  The header is structured as follows:


  WORD -- File ID -- $3D02

  WORD -- Count of objects in file (1-40)

  WORD -- Light source A on/off indicator (0=off, 1=on)
  WORD -- Light source B on/off indicator (0=off, 1=on)
  WORD -- Light source C on/off indicator (0=off, 1=on)

  WORD -- Light source A brightness (0-7)
  WORD -- Light source B brightness (0-7)
  WORD -- Light source C brightness (0-7)
  WORD -- Ambient light brightness (0-7)

  WORD -- Light source A Z position (-50 through +50)
  WORD -- Light source B Z position (-50 through +50)
  WORD -- Light source C Z position (-50 through +50)

  WORD -- Light source A Y position (-50 through +50)
  WORD -- Light source B Y position (-50 through +50)
  WORD -- Light source C Y position (-50 through +50)

  WORD -- Light source A X position (-50 through +50)
  WORD -- Light source B X position (-50 through +50)
  WORD -- Light source C X position (-50 through +50)

  32 WORDs -- Object color palette (BIOS format)
  32 WORDs -- Color group base array


                              - 76 -


  In order for the palette to be useful, it must be accompanied
  by the color group base array.  This array indicates the
  index of the first color in the group to which that color
  belongs.  In the following example palette, which contains a
  background color of black, followed by five reds, five greens
  and five blues, you can see how the palette base array is
  used to group the colors together.  The reds start at color
  index 1, the greens at color index 6, and the blues at color
  index 11.

  INDEX    COLOR     BASE
  -----    -----     ----
     0      000        0
     1      100        1
     2      200        1
     3      300        1
     4      400        1
     5      500        1
     6      010        6
     7      020        6
     8      030        6
     9      040        6
    10      050        6
    11      001       11
    12      002       11
    13      003       11
    14      004       11
    15      005       11

  The base value is used when performing shading operations,
  and if incorrectly set will result in odd-looking images.

  WORD -- Color palette type (0=Seven-shade, 1=Fourteen shade,
  2=Custom)

  WORD -- Wireframe line color (1-15)

  WORD -- Outline line color (0-15)

  150 BYTEs -- Filler for future expansion


  The object data is a variable-sized section which depends on
  the complexity of the object.  The section repeats for each
  object in the file, and is structured as follows:

  9 BYTEs -- Object name (8 characters max) with null
  terminator.

  WORD -- Number of vertices in object (15000 maximum)

  The following structure defines the X, Y and Z coordinates
  for each vertex of the object.  It is made up of three words
  and repeats the number of times specified by the vertex count


                              - 77 -


  word above.

  WORD -- X coordinate of vertex, stored in the standard CAD-3D
  fixed-point format.  For example, an X coordinate of 23.69 is
  stored as an integer value of 2369.  When reading this value,
  simply convert it to a floating-point variable and divide by
  100.

  WORD -- Y coordinate of vertex, also in fixed-point format.
  See above for description of format.

  WORD -- Z coordinate of vertex, also in fixed-point format.
  See above for description of the format.


  After all the vertices' coordinates have been read in, the
  next part of the file describes the triangular faces which
  make up the object.

  WORD -- Number of triangular faces in the object (30000
  maximum)

  The following structure tells the face structure of the
  object.  It is made up of four words and is repeated once for
  every face in the object, specified by the face count above.
  Each face is triangular, and defined by three vertices, or
  points, referred to as A, B and C.  When looking at the face
  of the triangle facing outward, the A-B-C order of the
  vertices is counterclockwise.  This allows for quick
  calculation of whether or not a face is visible.  Each face,
  in addition to having the three vertices of the triangle
  defined, has a color and edge-flag word.  This word tells the
  color of the face and whether or not the line of one of the
  three edges (A-B, B-C, C-A) is to be drawn in edges-only
  mode.

  WORD -- Number of first vertex in the face, termed point A.
  This value can range from zero to the number of vertices in
  the object, and corresponds to the vertices read from the
  file earlier.

  WORD -- Number of second vertex in the face, termed point B.
  This value can range from zero to the number of vertices in
  the object, and corresponds to the vertices read from the
  file earlier.

  WORD -- Number of the third vertex in the face, termed point
  C.  This value can range from zero to the number of vertices
  in the object, and corresponds to the vertices read from the
  file earlier.

  WORD -- Color/edge flag indicator.  The low byte of this
  value is a number from 1 to 15 and tells the color used for
  that face when drawing.  This value is used by the object
  shading routine to determine the color group within the


                              - 78 -


  palette used by this face.  The upper byte is used to tell
  the program which edges are to be shown by a line segment
  when drawing in "edges only" mode.  The three low-order bits
  in this byte are used as flags for this purpose; a zero in
  the bit indicates that no line is to be drawn, a one in the
  bit indicates that the edge is to be drawn.  The bit
  assignments are:

      Bit 2: Line segment A-B
      Bit 1: Line segment B-C
      Bit 0: Line segment C-A

  The face data repeats until all faces have been defined.
  This is the end of the file.


  SPIN TEMPLATE FILE FORMAT

  The CAD-3D spin tool template file is a convenient way to
  store often-used templates for spun objects.  It is an ideal
  way to send a simple spun object to another user of CAD-3D
  2.0 (they cannot be used by CAD-3D 1.0), since the compact
  template file is smaller than the resulting 3D object, making
  transmission via telecommunications network an economical
  option.

  The template file contains all information necessary to
  create a spun object except for the number of degrees or the
  percentage for a partial spin.  The file contains the number
  of points in the template, the number of segments, a flag
  which tells whether or not the first point is connected to
  the last, and the actual coordinate data for the template.

  The format of the file is as follows:

  WORD -- Number of points in the template, a number from 1 to
  99.

  WORD -- Number of segments in the spun object, a number from
  1 to 48.  Note that segment values less than 3 may not
  execute in partial or full spin operations.

  WORD -- Connect flag.  0 indicates that the first point and
  the last point are not connected, 1 indicates that they are
  connected.  When a template is loaded, the "Connect"
  selection in the drop-down menu will be set to the
  appropriate setting.

  The following section of the file is a table of the X
  coordinates of all the points in the template.  There are n
  WORDs in this table, where n is the number of points in the
  template, specified in the first word of the file.

  n WORDs -- The values of the X coordinates of the points in


                              - 79 -


  the spin template.  These values range from 0 to 300.  A
  value of zero indicates that the point lies on the spin
  tool's central axis at the center of the spin tool window; a
  value of 300 indicates that the point lies at the far right
  of the window.

  The following section of the file is a table of the Y
  coordinates of all the points in the template.  There are n
  WORDs in this table, where n is the number of points in the
  template, specified in the first word of the file.

  n WORDs -- The values of the Y coordinates of the points in
  the spin template.  These values range from -150 to 150.  A
  value of -150 indicates that the point lies at the top of the
  spin tool window; a value of 150 indicates that the point
  lies at the bottom of the window.


  EXTRUDE TEMPLATE FILE FORMAT

  The CAD-3D extrude tool template file is almost exactly the
  same as the spin tool template file.

  The template file contains all information necessary to
  create an extruded object.  It contains the number of points
  in the template, the number of segments, and the actual
  coordinate data for the template.

  The format of the file is as follows:

  WORD -- Number of points in the template, a number from 1 to
  99.

  WORD -- Number of segments in the spun object, a number from
  1 to 50.

  The following section of the file is a table of the X
  coordinates of all the points in the template.  There are n
  WORDs in this table, where n is the number of points in the
  template, specified in the first word of the file.

  n WORDs -- The values of the X coordinates of the points in
  the spin template.  These values range from -300 to 300.  A
  value of -300 indicates that the point lies at the far left
  of the extrude tool window; a value of 300 indicates that the
  point lies at the far right of the window.

  The following section of the file is a table of the Y
  coordinates of all the points in the template.  There are n
  WORDs in this table, where n is the number of points in the
  template, specified in the first word of the file.

  n WORDs -- The values of the Y coordinates of the points in
  the extrude template.  These values range from -150 to 150.


                              - 80 -


  A value of -150 indicates that the point lies at the top of
  the extrude tool window; a value of 150 indicates that the
  point lies at the bottom of the window.


                Section 6:  CAD-3D 2.0 Specifics


  NON-STANDARD AXIS LABELING

  CAD-3D uses a non-standard coordinate system, and it is
  important to remember how this system is oriented when using
  the communication pipe.

  Cad-3D's coordinate system is oriented as follows:

  The X axis, as viewed from the top of the universe (see the
  TOP view window) runs from left to right.  The lowest X value
  an object can have is -45.00 (the left side of the window),
  and the highest value is 45.00 (the right side of the
  window).

  The Y axis, as viewed from the top of the universe (see the
  TOP view window) runs from bottom to top.  The lowest Y value
  an object can have is -45.00 (the bottom of the window), and
  the highest value is 45.00 (the top of the window).  This is
  considered non-standard by most people, as this axis is
  usually considered the Z axis.

  The Z axis, as viewed from the front of the universe (see the
  FRONT window) runs from bottom to top.  The lowest Z value is
  -45.00 (the bottom of the window), and the highest value is
  45.00 (the top of the window).  This is also condsidered
  non-standard, as this is axis is usually labeled as the Y
  axis.

  The reason the axis system is non-standard is due to the way
  I learned 3D graphics, which was charting in geometry.  In
  most examples, the X and Y axes were always a sheet of graph
  paper on a desktop, and the Z values were "altitudes" above
  or below the sheet.  The lack of formal education in this
  area led to the 3D axes being "mis-labeled" from the
  standpoint of most 3D users.

  The non-standard orientation has been preserved in this
  version in order to remain compatible with the previous
  version of CAD-3D.  If this causes problems for you, just
  exchange the Y and Z axes when working with them in CAD-3D.


  OBJECT NAME CONVENTIONS

  Because CAD-3D allows you to refer to objects by name, it is
  very easy for most people to use.  When naming your objects,
  please use meaningful names so that they can be easily
  recognized.  Names such as WINGLET are much easier to
  identify than names like XXX.  It's especially important to
  name objects well if you'll be exchanging your files with
  others.


                              - 83 -


  Object names in CAD-3D can be up to eight characters in
  length, and are case-sensitive.  This allows very flexible
  naming of objects.  Be sure you are using the proper name
  when using the communication pipe -- "ABC" is not the same as
  "abc" or "ABc".  If you use the communication pipe for
  manipulation of objects, you must be careful to use the
  proper name or CAD-3D will not find the object.


  "FIXED-POINT" MATH FORMAT

  CAD-3D 2.0's communication pipe and file formats use an
  integer format to store floating-point values.  This is done
  to save disk space and make the program compatible with other
  compilers which may use a different floating-point format.
  The fixed-point format used is simply the integer equivalent
  of the floating-point value multiplied by 100.  This results
  in values with two digits to the right of the decimal (i.e.
  1.567 becomes 1.56).  This precision is used because two
  decimal places is the precision used in the boolean shape
  operations in the JOIN function.  The Motorola Fast Floating
  Point library is used in CAD-3D, and the 3D object vertex
  coordinates had to be truncated to two decimal places in
  order to avoid serious problems with the math results.

  For this reason, you should keep your objects as large as
  possible when executing JOIN operations -- it will prevent
  extreme truncation.


                              - 84 -


    SOFTWARE ETHICS


    The retail purchaser of this computer program does not have the right
    to exercise any of the exclusive rights of copyright reserved by the
    author of this program, which include:
    (1) the right to reproduce or otherwise make copies of this program,
    other than an archival copy (as described below);
    (2) the right to distribute copies of the program;
    (3) the right to publicly perform the program;
    (4) the right to publicly display the program; and
    (5) the right to prepare derivative works based on the program.
    (Section 106, U.S. Copyright Act of 1976, as amended, Public Law
    94-553, Oct. 19, 1976).

    In accordance with Section 117 of the Copyright Act, the purchaser has
    a limited right to make a copy of this program only in the following
    two situations:

    (1) the new copy is created as an essential step in utilization of the
    program; or

    (2) the new copy is for archival purposes.

    All archival copies must be destroyed in the event that the original
    purchaser ceases to own the original copy of the program.  Section 117,
    U.S. Copyright Act of 1976, as amended by Public Law 96-517, dated Dec.
    12, 1980.

    The propriety of respecting the copyright owner's rights in his
    creation (after all, that's how he earns his living) is reflected in
    the range of penalties that the law affords to the copyright owner,
    which include: injunctive relief (Section 502); forefeiture of all
    infringing and contributorily infringing items (Section 503); monetary
    damages (Section 504); and criminal sanctions, including imprisonment
    (Section 506).

    The holder of the copyright of CAD-3D 2.0 DEVELOPER'S DISK is Tom
    Hudson.


    CAD-3D 2.0 DEVELOPER'S DISK is a trademark of Antic Publishing, Inc.


                              - 85 -
