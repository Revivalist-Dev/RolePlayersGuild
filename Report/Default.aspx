<%@ Page Title="Contact the Staff at RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Report.Default" %>
<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>

<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <h1>Contact Staff</h1>

    <asp:FormView ID="FormView1" runat="server" DataKeyNames="ItemID" DataSourceID="sdsToDoItems" DefaultMode="Insert" Width="100%" OnItemInserted="FormView1_ItemInserted">
        <InsertItemTemplate>
            <div class="clearfix">
                <div class="col-sm-6" style="margin: 1em 0;">
                    <label>Title:</label>
                    <asp:TextBox ID="ItemNameTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemName") %>' MaxLength="200" />
                </div>
                <div class="col-sm-12" style="margin: 1em 0;">
                    <label>Description:</label>
                    <asp:TextBox ID="ItemDescriptionTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemDescription") %>' TextMode="MultiLine" Rows="5" placeholder="Please include as much detail about the problem as you can." />
                </div>
            </div>
            <div class="col-sm-12 clearfix" style="margin: 1em 0;">
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="btn btn-primary">Send Message</asp:LinkButton>
            </div>
        </InsertItemTemplate>
    </asp:FormView>

    <asp:SqlDataSource ID="sdsToDoItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" DeleteCommand="DELETE FROM [ToDo_Items] WHERE [ItemID] = @ItemID" InsertCommand="INSERT INTO [ToDo_Items] ([ItemName], [ItemDescription], [StatusID], [TypeID], [AssignedToUserID], [CreatedByUserID]) VALUES (@ItemName, @ItemDescription, 1, 4, 0, @CreatedByUserID)" SelectCommand="SELECT * FROM [ToDo_Items]" UpdateCommand="UPDATE [ToDo_Items] SET [ItemName] = @ItemName, [ItemDescription] = @ItemDescription, [StatusID] = @StatusID, [TypeID] = @TypeID, [AssignedToUserID] = @AssignedToUserID, [CreatedByUserID] = @CreatedByUserID, [ThreadID] = @ThreadID WHERE [ItemID] = @ItemID">
        <InsertParameters>
            <asp:Parameter Name="ItemName" Type="String" />
            <asp:Parameter Name="ItemDescription" Type="String" />
            <asp:SessionParameter Name="CreatedByUserID" SessionField="UserID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>

</asp:Content>
