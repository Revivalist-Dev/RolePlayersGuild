using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.ChatRooms.Room
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["id"] == null)
            { Response.Redirect("/Chat-Rooms/"); }
            else
            {
                Master.PnlLeftCol.CssClass = "col-sm-3 col-xl-2";
                Master.PnlRightCol.CssClass = "col-sm-9 col-xl-10";
                //templates.controls.ChatRoom myChatRoom = new templates.controls.ChatRoom();
                //myChatRoom.ChatRoomID = Request.QueryString["id"];

                int ChatRoomID = 0;

                if (!int.TryParse(Request.QueryString["id"], out ChatRoomID))
                {
                    Response.Redirect("/Chat-Rooms/", false);
                }

                ucChatRoom.ChatRoomID = ChatRoomID.ToString();
                DataTable CurrentChatRoomInfo = DataFunctions.Tables.GetDataTable("Select * From Chat_Rooms Where ChatRoomID = @ParamOne", ChatRoomID);
                if (CurrentChatRoomInfo.Rows.Count == 0)
                {
                    Response.Redirect("/Chat-Rooms/", false);
                }
                else
                {
                    ucChatRoom.RatingID = CurrentChatRoomInfo.Rows[0]["ContentRatingID"].ToString();
                    ucChatRoom.ChatRoomName = CurrentChatRoomInfo.Rows[0]["ChatRoomName"].ToString();
                    Page.Title = CurrentChatRoomInfo.Rows[0]["ChatRoomName"].ToString() + " on RPG";
                }
                //phChatRoom.Controls.Add(myChatRoom);
            }
        }

    }
}