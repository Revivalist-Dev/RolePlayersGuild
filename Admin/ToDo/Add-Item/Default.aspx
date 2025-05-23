<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.ToDo.Add.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">

    <asp:FormView ID="FormView1" runat="server" DataKeyNames="ItemID" DataSourceID="sdsToDoItems" DefaultMode="Insert" Width="100%" OnItemInserted="FormView1_ItemInserted">
        <InsertItemTemplate>
            <div class="clearfix">
                <div class="col-sm-6">
                    <label>Title:</label>
                    <asp:TextBox ID="ItemNameTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemName") %>' MaxLength="200" />
                </div>
                <div class="col-sm-12">
                    <label>Description:</label>
                    <asp:TextBox ID="ItemDescriptionTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemDescription") %>' TextMode="MultiLine" Rows="5" />
                </div>
                <div class="col-sm-4">
                    <label>Status:</label>
                    <asp:DropDownList ID="DropDownList4" runat="server" CssClass="form-control" DataSourceID="sdsTodoStatuses" DataTextField="StatusName" DataValueField="StatusID" SelectedValue='<%# Bind("StatusID") %>'>
                    </asp:DropDownList>
                </div>
                <div class="col-sm-4">
                    <label>Type:</label>
                    <asp:DropDownList ID="DropDownList5" runat="server" CssClass="form-control" DataSourceID="sdsToDoTypes" DataTextField="TypeName" DataValueField="TypeID" SelectedValue='<%# Bind("TypeID") %>'>
                    </asp:DropDownList>
                </div>
                <div class="col-sm-4">
                    <label>Assigned To:</label>
                    <asp:DropDownList ID="DropDownList6" runat="server" CssClass="form-control" DataSourceID="sdsAssignToUsers" DataTextField="Username" DataValueField="UserID" SelectedValue='<%# Bind("AssignedToUserID") %>' AppendDataBoundItems="true">
                        <asp:ListItem Value="0" Text="No One"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <a href="../" class="btn btn-danger">Cancel</a>
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12"></div>
                <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="btn btn-success"><span class="glyphicon glyphicon-plus"></span>&nbsp;To-Do Item</asp:LinkButton>
                </div>
            </div>
            <div class="clearfix" style="margin: 1em 0;">
            </div>
        </InsertItemTemplate>
    </asp:FormView>

    <asp:SqlDataSource ID="sdsTodoStatuses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT StatusID, StatusName FROM ToDo_Item_Statuses ORDER BY StatusName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsToDoTypes" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [TypeID], [TypeName] FROM [ToDo_Item_Types] ORDER BY [TypeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsAssignToUsers" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT UserID, CAST(UserID AS Nvarchar) + ' - ' + ISNULL(Username, '') AS Username FROM Users Where UserTypeID = 2 or UserTypeID = 3 or UserTypeID = 4"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsToDoItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" InsertCommand="INSERT INTO ToDo_Items(ItemName, StatusID, TypeID, AssignedToUserID, CreatedByUserID, ItemDescription) VALUES (@ItemName, @StatusID, @TypeID, @AssignedToUserID, @CreatedByUserID, @ItemDescription)">
        <InsertParameters>
            <asp:Parameter Name="ItemName" Type="String" />
            <asp:Parameter Name="StatusID" Type="Int32" />
            <asp:Parameter Name="TypeID" Type="Int32" />
            <asp:Parameter Name="AssignedToUserID" Type="Int32" />
            <asp:SessionParameter Name="CreatedByUserID" SessionField="UserID" Type="Int32" />
            <asp:Parameter Name="ItemDescription" />
        </InsertParameters>
    </asp:SqlDataSource>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
