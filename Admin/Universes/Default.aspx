<%@ Page Title="Manage Universes on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.Universes.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>

    <div class="col-xs-3">
        <asp:ListBox ID="lbUniverses" runat="server" Width="100%" Rows="45" DataSourceID="sdsUniverses" DataTextField="UniverseName" DataValueField="UniverseID" AutoPostBack="True" OnSelectedIndexChanged="lbUniverses_SelectedIndexChanged" OnDataBound="lbUniverses_DataBound"></asp:ListBox>
        <asp:SqlDataSource ID="sdsUniverses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [UniverseID], Case When [StatusID] = 1 Then '[PA] - ' + [UniverseName] else [UniverseName] End As UniverseName FROM [Universes] ORDER BY [StatusID], [UniverseName]"></asp:SqlDataSource>
    </div>
    <div runat="server" id="divTools" class="col-xs-9">
        <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
            <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
        </asp:Panel>
        <asp:HyperLink ID="lnkUniverse" runat="server">Visit Universe &raquo;</asp:HyperLink>
        <%--<h1>
            <asp:Literal ID="litUniverseName" runat="server"></asp:Literal></h1>--%>
        <div>
            <div class="form-group">
                <label for="txtUniverseName">Universe Name</label>
                <asp:TextBox ID="txtUniverseName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtDescription">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" Width="100%" Rows="15" TextMode="MultiLine" CssClass="form-control" ValidateRequestMode="Disabled"></asp:TextBox>
            </div>
            <div class="form-group clearfix">
                <label for="cblGenres">Genres</label>
                <div class="FancyCheckList GenreList">
                    <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" CssClass="FancyCheck" OnDataBound="cblGenres_DataBound"></asp:CheckBoxList>
                    <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
                </div>
            </div>

            <div class="form-group">
                <label for="ddlSource">Content Source</label>
                <div class="input-group">
                    <asp:DropDownList ID="ddlSource" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Fan-Fic" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Original" Value="1"></asp:ListItem>
                    </asp:DropDownList>
                    <span class="input-group-btn">
                        <a href="#" data-toggle="modal" data-target="#SourceDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
                    </span>
                </div>
            </div>

            <div class="form-group">
                <label for="ddlRating">Content Rating</label>
                <div class="input-group">
                    <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Teen" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Mature" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                    <span class="input-group-btn">
                        <a href="#" data-toggle="modal" data-target="#RatingDescription" class="btn btn-info" tabindex="-1"><span class="glyphicon glyphicon-question-sign"></span></a>
                    </span>
                </div>
            </div>
            <div class="form-group">
                <asp:HyperLink ID="lnkOwnerLink" runat="server">Owner</asp:HyperLink>
            </div>
            <div class="form-group">
                <asp:HyperLink ID="lnkSubmittedBy" runat="server">Owner</asp:HyperLink>
            </div>
            <div class="checkbox FancyCheck">
                <asp:CheckBox ID="chkApproved" ClientIDMode="Static" runat="server" Text="Universe is approved." />
            </div>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12">
                    <asp:HyperLink ID="lnkDeleteUniverse" runat="server" Text="Delete Universe" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteUniverseModal" />
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12">
                </div>
                <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                    <asp:Button ID="btnSaveUniverse" runat="server" Text="Save Universe" CssClass="btn btn-success" OnClick="btnSaveUniverse_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
    <div class="modal fade" id="DeleteUniverseModal" tabindex="-1" role="dialog" aria-labelledby="DeleteUniverseLabel" runat="server" clientidmode="Static">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="DeleteUniverseLabel">Are you sure?</h4>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this universe?</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnDeleteUniverse" runat="server" Text="Delete Universe" CssClass="btn btn-danger" OnClick="btnDeleteUniverse_Click" />

                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
