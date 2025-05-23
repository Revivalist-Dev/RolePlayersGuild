using RolePlayersGuild.templates.controls.subcontrols;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace RolePlayersGuild.templates.controls
{
    public partial class EditImage : System.Web.UI.UserControl
    {
        public string ScreenStatus { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

            //foreach (object MyControl in ImageUploadAccordionItem.Controls)
            //{ Response.Write(MyControl.ToString() + "<br>"); }

            //pnlImageAccordion.Controls.Add(new ImageUploadAccordionItem());
            //pnlImageAccordion.Controls.Add(new TextBox());
            //pnlImageAccordion.Controls.Add(new ImageUploadAccordionItem());
            //pnlImageAccordion.Controls.Add(new TextBox());
            //pnlImageAccordion.Controls.Add(new ImageUploadAccordionItem());

            if (Request.QueryString["GalleryID"] != null)
            {

                int CharacterID = int.Parse(Request.QueryString["GalleryID"].ToString());
                int intUserID = DataFunctions.Scalars.GetUserID(CharacterID);

                if (intUserID == (int)Session["UserID"] || CookieFunctions.IsStaff)
                {

                    if (!Page.IsPostBack)
                    {
                        switch (ScreenStatus)
                        {
                            case "Edit":
                                //UpdatePanel1.Visible = false;
                                btnAddImage.Text = "Save Image";
                                pnlEditImage.Visible = true;
                                pnlProfileImage.Controls.Clear();
                                if (Request.QueryString["ImageID"] != null)
                                {
                                    litTitle.Text = "Edit Image";

                                    DataRow drImage = DataFunctions.Records.GetImage(int.Parse(Request.QueryString["ImageID"]));

                                    if (drImage != null && (int.Parse(drImage["UserID"].ToString()) == (int)Session["UserID"] || CookieFunctions.IsStaff))
                                    {
                                        txtCaption.Text = drImage["ImageCaption"].ToString();
                                        chkMakePrimary.Checked = bool.Parse(drImage["IsPrimary"].ToString());
                                        //chkMatureContent.Checked = bool.Parse(drImage["IsMature"].ToString());

                                        Image CurrentImage = new Image();
                                        CurrentImage.ImageUrl = StringFunctions.DisplayImageString(drImage["CharacterImageURL"].ToString(), "thumb");

                                        pnlProfileImage.Controls.Add(CurrentImage);
                                    }
                                    else
                                    {
                                        Response.Redirect("/", true);
                                    }
                                }
                                else
                                {
                                    Response.Redirect("/", true);
                                }
                                Page.Title = "Edit Image on RPG";
                                break;
                            case "New":
                                litTitle.Text = "New Images";
                                //rblImagesToUpload.SelectedValue = "1";
                                Page.Title = "Add Images on RPG";
                                break;
                        }
                    }
                }
                else
                {
                    Response.Redirect("/", true);
                }
                if (ScreenStatus == "New")
                {
                    GenerateAccordionItems(CharacterID);
                }
            }
            else
            {
                Response.Redirect("/", true);
            }


        }

        protected void btnAddImage_Click(object sender, EventArgs e)
        {
            int CharacterID = int.Parse(Request.QueryString["GalleryID"].ToString());

            switch (ScreenStatus)
            {
                case "Edit":
                    //var rpgCharacterImages = new rpgDBTableAdapters.Character_ImagesTableAdapter();
                    if (chkMakePrimary.Checked)
                    {
                        DataFunctions.Updates.RemoveDefaultFlagFromImages(CharacterID);
                    }

                    DataFunctions.Updates.UpdateImage(int.Parse(Request.QueryString["ImageID"].ToString()), chkMakePrimary.Checked, false, txtCaption.Text);
                    Response.Redirect("/Gallery?id=" + CharacterID.ToString(), true);
                    break;
                case "New":

                    var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                    con.Open();
                    foreach (ImageUploadAccordionItem AccordionItem in phAccordion.Controls)
                    {
                        FileUpload fuCharacterImage = (FileUpload)AccordionItem.FindControl("fuCharacterProfileImage");
                        CheckBox AccordionchkMakePrimary = (CheckBox)AccordionItem.FindControl("chkMakePrimary");
                        //CheckBox AccordionchkMatureContent = (CheckBox)AccordionItem.FindControl("chkMatureContent");
                        TextBox AccordiontxtCaption = (TextBox)AccordionItem.FindControl("txtCaption");
                        //Response.Write(fuCharacterImage.UniqueID + " - Has Image? " + fuCharacterImage.HasFile + "<br>");
                        if (fuCharacterImage.HasFile)
                        {
                            string ImagePath = ImageFunctions.UploadImage(fuCharacterImage);
                            if (ImagePath.Length > 0)
                            {
                                if (AccordionchkMakePrimary.Checked)
                                {
                                    var scUpdateImages = new SqlCommand("UPDATE Character_Images SET IsPrimary = 0 WHERE (CharacterID = @CharID)", con);
                                    scUpdateImages.Parameters.AddWithValue("CharID", CharacterID);
                                    scUpdateImages.ExecuteNonQuery();
                                }
                                var scInsertImage = new SqlCommand("INSERT INTO Character_Images (CharacterImageURL, CharacterID, IsPrimary, ImageCaption) VALUES (@Url,@CharID,@Primary, @Caption)", con);
                                scInsertImage.Parameters.AddWithValue("Url", ImagePath);
                                scInsertImage.Parameters.AddWithValue("CharID", CharacterID);
                                scInsertImage.Parameters.AddWithValue("Primary", AccordionchkMakePrimary.Checked);
                                //scInsertImage.Parameters.AddWithValue("Mature", AccordionchkMatureContent.Checked);
                                scInsertImage.Parameters.AddWithValue("Caption", AccordiontxtCaption.Text);
                                scInsertImage.ExecuteNonQuery();
                            }
                        }
                    }
                    con.Close();

                    Response.Redirect("/Gallery?id=" + CharacterID.ToString(), true);
                    break;
            }
        }

        protected void rblImagesToUpload_SelectedIndexChanged(object sender, EventArgs e)
        {

            //GenerateAccordionItems();

            //btnAddImage.Visible = true;
        }
        protected void GenerateAccordionItems(int CharacterID)
        {
            int ImageMaxPerCharacter = int.Parse(ConfigurationManager.AppSettings["ImageMaxPerCharacter"].ToString());
            int AvailableImageCount = (int)DataFunctions.Scalars.GetSingleValue("Select (@ParamTwo - (Select Count(CharacterID) from Character_Images where CharacterID = @ParamOne))", CharacterID, ImageMaxPerCharacter);

            int MembershipTypeID = DataFunctions.Scalars.GetMembershipTypeID(CookieFunctions.UserID);
            CookieFunctions.MembershipTypeID = MembershipTypeID;

            if (AvailableImageCount < 0) AvailableImageCount = 0;
            //{
            //}
            int UsedImageSlots = DataFunctions.Scalars.GetUsedUpImageSlotCount(CookieFunctions.UserID, ImageMaxPerCharacter);

            switch (MembershipTypeID)
            {
                case 1:
                    AvailableImageCount += (int.Parse(ConfigurationManager.AppSettings["BronzeMemberImageMax"].ToString()) - UsedImageSlots);
                    break;
                case 2:
                    AvailableImageCount += (int.Parse(ConfigurationManager.AppSettings["SilverMemberImageMax"].ToString()) - UsedImageSlots);
                    break;
                case 3:
                    AvailableImageCount += (int.Parse(ConfigurationManager.AppSettings["GoldMemberImageMax"].ToString()) - UsedImageSlots);
                    break;
                case 4:
                    AvailableImageCount += (int.Parse(ConfigurationManager.AppSettings["PlatinumMemberImageMax"].ToString()) - UsedImageSlots);
                    break;
            }

            if (AvailableImageCount > 0)
            {
                for (int i = 1; i <= AvailableImageCount; i++)
                {
                    ImageUploadAccordionItem AccordionItem = new ImageUploadAccordionItem();
                    AccordionItem = (ImageUploadAccordionItem)LoadControl("~/templates/controls/subcontrols/ImageUploadAccordionItem.ascx");
                    AccordionItem.AccordionNumber = i.ToString();
                    AccordionItem.ID = "AccordionItem_" + i;
                    phAccordion.Controls.Add(AccordionItem);
                    if (i == 15) break;
                }
            }
            else {
                pnlImageAccordion.CssClass = "alert alert-warning";
                Literal litMessage = new Literal();
                litMessage.Text = "<h3>Want to upload more images?</h3> <p>Unfortunately, it seems you've hit your image cap. If you would like to add new images, you can purchase a paid membership for as low as $10/year to add more image slots to all of your characters.</p><br><p><a href=\"/Memberships\" class=\"btn btn-primary\">Get a Paid Membership</a></p>";
                phAccordion.Controls.Add(litMessage);
                btnAddImage.Visible = false;
            }
        }
        //protected void btnAddAccordionItem_Click(object sender, EventArgs e)
        //{
        //    int AccordionItemCount = phAccordion.Controls.Count + 1;

        //    ImageUploadAccordionItem AccordionItem = (ImageUploadAccordionItem)LoadControl("~/templates/controls/subcontrols/ImageUploadAccordionItem.ascx");
        //    AccordionItem.AccordionNumber = AccordionItemCount.ToString();
        //    phAccordion.Controls.Add(AccordionItem);


        //}
    }
}